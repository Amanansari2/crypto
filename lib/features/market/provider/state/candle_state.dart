import '../../domain/entities/binance/candle_entity.dart';

class CandleState {
  final List<CandleEntity> candles;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int? endTime;
  final bool hasMoreData;

  const CandleState({
    this.candles = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.endTime,
    this.hasMoreData = true,
  });

  CandleState copyWith({
    List<CandleEntity>? candles,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? endTime,
    bool? hasMoreData,
  }) {
    return CandleState(
      candles: candles ?? this.candles,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      endTime: endTime ?? this.endTime,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}
