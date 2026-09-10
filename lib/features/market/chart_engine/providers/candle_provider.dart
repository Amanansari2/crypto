import 'package:crypto_app/features/market/chart_engine/core/models/interval_model.dart';
import 'package:crypto_app/features/market/chart_engine/providers/viewport_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/websocket/trading_backend_socket_service.dart';
import '../core/models/candle_model.dart';
import '../data/datasource/candle_rest_source.dart';
import 'chart_width_provider.dart';
import 'interval/selected_interval_provider.dart';

final candleProvider = AsyncNotifierProvider<CandleNotifier, List<CandleModel>>(
  CandleNotifier.new,
);

final candleLoadingMoreProvider =
NotifierProvider<
    CandleLoadingMore,
    bool
>(
  CandleLoadingMore.new,
);

class CandleLoadingMore extends Notifier<bool> {
  @override
  bool build() => false;
}

class CandleNotifier extends AsyncNotifier<List<CandleModel>> {
  late final CandleRestSource _source;
  late final TradingBackendSocketService _socket;

  String _symbol = "BTCUSDT";
  //  String? _symbol;

  late String _interval;

  int? _nextEndTime;

  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<CandleModel>> build() async {
    _source = CandleRestSource();
    _socket = TradingBackendSocketService();

    final selectedInterval = ref.read(selectedIntervalProvider);
    _interval = selectedInterval.value;

    ref.onDispose(() {
      _socket.unsubscribeKlines(
        _symbol,
        _interval,
      );
    });

    _socket.messages
        .where(
          (message) =>
      message['type'] == 'KLINE' &&
          message['data'] != null,
    )
        .listen((message) {
      final data = message['data'];

      if (data['symbol'] != _symbol) {
        return;
      }

      if (data['interval'] != _interval) {
        return;
      }

      addLiveCandle(
        CandleModel.fromJson(data),
      );
    });

    return await loadInitial();

  }

  Future<List<CandleModel>> loadInitial({
    String? symbol,

    String? interval,
  }) async {
    _symbol = symbol ?? _symbol;

    _interval = interval ?? _interval;

    final result = await _source.getCandles(
      symbol: _symbol,

      interval: _interval,

      limit: 300,
    );

    _nextEndTime = result.$2;
      _socket.subscribeKlines(_symbol, _interval);
    return result.$1;
  }

  Future<void> changeSymbol(String symbol,) async {
    state = const AsyncLoading();

    try {
      _socket.unsubscribeKlines(
        _symbol,
        _interval,
      );
      _symbol = symbol;

      _nextEndTime = null;

      final candles =
      await loadInitial(
        symbol: symbol,
      );

      state =
          AsyncData(candles);
    } catch (e, st) {
      state =
          AsyncError(e, st);
    }
  }


  Future<int> loadMore() async {
    if (_isLoadingMore) {
      return 0;
    }

    if (_nextEndTime == null) {
      return 0;
    }

    _isLoadingMore = true;
    ref
        .read(candleLoadingMoreProvider.notifier)
        .state = true;
    final startTime = DateTime.now();

    try {
      final result =
      await _source.getCandles(

        symbol: _symbol,

        interval: _interval,

        limit: 200,

        endTime: _nextEndTime,
      );

      final elapsed = DateTime.now().difference(startTime);
      if (elapsed.inMilliseconds < 2000) {
        await Future.delayed(
          Duration(milliseconds: 2000 - elapsed.inMilliseconds,),
        );
      }

      _nextEndTime = result.$2;

      final oldCandles =
          state.value ?? [];

      final newCandles =
          result.$1;

      state = AsyncData([

        ...newCandles,

        ...oldCandles,
      ]);

      return newCandles.length;

    } catch (e, st) {

      state = AsyncError(e, st);

      return 0;

    } finally {
      _isLoadingMore = false;
      ref
          .read(candleLoadingMoreProvider.notifier)
          .state = false;
    }
  }

  Future<void> changeInterval(String interval) async {
    state = const AsyncLoading();

    try {
      _socket.unsubscribeKlines(
        _symbol,
        _interval,
      );
      _interval = interval;

      ref.read(selectedIntervalProvider.notifier).change(
        IntervalModel(label: interval, value: interval)
      );


      _nextEndTime = null;

      final candles = await loadInitial(interval: interval);

      state = AsyncData(candles);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void addLiveCandle(CandleModel candle) {
    final candles = [...?state.value];

    if (candles.isEmpty) return;

    final last = candles.last;
    final viewport = ref.read(viewportProvider);
    final wasAtLatest = viewport.isAtLatest;
    bool isNewCandle = false;

    /// same candle update
    if (last.time == candle.time) {
      candles[candles.length - 1] = candle;
    } else {
      candles.add(candle);
      isNewCandle = true;
    }

    state = AsyncData(candles);
    
    if(isNewCandle){

      if(wasAtLatest){
        Future.microtask((){
          final chartWidth = ref.read(chartWidthProvider);
          
          ref.read(viewportProvider.notifier).setScroll(
              candles.length * viewport.candleWidth,
              candles.length,
              chartWidth);
        });
      }
    }
  }


}
