import '../../entities/binance/candle_entity.dart';

abstract class CandleRepository {
  Future<(List<CandleEntity>, int?)> getCandles({
    required String symbol,
    required String interval,
    int? endTime,
  });
}
