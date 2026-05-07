import '../../entities/binance/candle_entity.dart';
import '../../repositories/binance/candle_repository.dart';

class GetCandlesUseCase {
  final CandleRepository repository;

  GetCandlesUseCase(this.repository);

  Future<(List<CandleEntity>, int?)> call({
    required String symbol,
    required String interval,
    int? endTime,
  }) {
    return repository.getCandles(
      symbol: symbol,
      interval: interval,
      endTime: endTime,
    );
  }
}
