import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/candle_model.dart';
import '../data/datasource/candle_rest_source.dart';

final candleProvider = AsyncNotifierProvider<CandleNotifier, List<CandleModel>>(
  CandleNotifier.new,
);

class CandleNotifier extends AsyncNotifier<List<CandleModel>> {
  late final CandleRestSource _source;

  String _symbol = "BTCUSDT";

  String _interval = "1m";

  int? _nextEndTime;

  bool _isLoadingMore = false;

  @override
  Future<List<CandleModel>> build() async {
    _source = CandleRestSource();

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

    return result.$1;
  }

  Future<void> changeSymbol(String symbol,) async {
    state = const AsyncLoading();

    try {
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


  Future<void> loadMore() async {
    if (_isLoadingMore) return;

    if (_nextEndTime == null) return;

    _isLoadingMore = true;

    try {
      final result = await _source.getCandles(
        symbol: _symbol,

        interval: _interval,

        limit: 200,

        endTime: _nextEndTime,
      );

      _nextEndTime = result.$2;

      final oldCandles = state.value ?? [];

      state = AsyncData([...result.$1, ...oldCandles]);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> changeInterval(String interval) async {
    state = const AsyncLoading();

    try {
      _interval = interval;
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

    /// same candle update
    if (last.time == candle.time) {
      candles[candles.length - 1] = candle;
    } else {
      candles.add(candle);
    }

    state = AsyncData(candles);
  }
}
