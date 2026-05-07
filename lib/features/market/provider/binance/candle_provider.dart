import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/binance/candle_usecase.dart';
import '../state/candle_state.dart';
import '../useCase/candle_usecase.dart';

final candleProvider = NotifierProvider<CandleNotifier, CandleState>(() {
  return CandleNotifier();
});

class CandleNotifier extends Notifier<CandleState> {
  late final GetCandlesUseCase useCase;

  String currentSymbol = "BTCUSDT";
  String currentInterval = "1m";

  /// 🔥 prevent duplicate API calls
  final Set<int> _fetchedEndTimes = {};

  /// 🔥 max candles in memory
  final int maxCacheSize = 1500;

  @override
  CandleState build() {
    useCase = ref.watch(getCandlesUseCaseProvider);
    return const CandleState(hasMoreData: true);
  }

  /// 🔥 Initial load
  Future<void> loadInitial({
    required String symbol,
    required String interval,
  }) async {
    currentSymbol = symbol;
    currentInterval = interval;

    _fetchedEndTimes.clear();

    state = state.copyWith(isLoading: true, error: null, hasMoreData: true);

    try {
      final (candles, endTime) = await useCase(
        symbol: symbol,
        interval: interval,
      );

      state = state.copyWith(
        candles: candles,
        endTime: endTime,
        isLoading: false,
        hasMoreData: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 🔥 Pagination (LEFT SCROLL)
  Future<void> loadMore() async {
    if (state.isLoading ||
        state.isLoadingMore ||
        state.endTime == null ||
        !state.hasMoreData)
      return;

    final currentEndTime = state.endTime!;

    if (_fetchedEndTimes.contains(currentEndTime)) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final (candles, nextEndTime) = await useCase(
        symbol: currentSymbol,
        interval: currentInterval,
        endTime: currentEndTime,
      );

      /// 🔥 mark fetched AFTER success
      _fetchedEndTimes.add(currentEndTime);

      /// ❌ no more data
      if (candles.isEmpty) {
        state = state.copyWith(isLoadingMore: false, hasMoreData: false);
        return;
      }

      /// 🔥 merge
      final merged = [...candles, ...state.candles];

      /// 🔥 remove duplicates
      final unique = {for (var c in merged) c.time: c}.values.toList();

      /// 🔥 sort
      unique.sort((a, b) => a.time.compareTo(b.time));

      /// 🔥 sliding window (limit memory)
      if (unique.length > maxCacheSize) {
        unique.removeRange(0, unique.length - maxCacheSize);
      }

      state = state.copyWith(
        candles: unique,
        endTime: nextEndTime,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  /// 🔥 Interval change
  Future<void> changeInterval(String interval) async {
    if (interval == currentInterval) return;

    currentInterval = interval;

    _fetchedEndTimes.clear();

    state = state.copyWith(
      endTime: null,
      isLoadingMore: false,
      hasMoreData: true,
    );

    await loadInitial(symbol: currentSymbol, interval: interval);
  }
}
