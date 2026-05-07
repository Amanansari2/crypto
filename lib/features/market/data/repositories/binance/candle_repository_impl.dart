import '../../../domain/entities/binance/candle_entity.dart';
import '../../../domain/repositories/binance/candle_repository.dart';
import '../../datasources/binance/rest/candle_remote_datasource.dart';

class CandleRepositoryImpl implements CandleRepository {
  final CandleRemoteDatasource remote;

  CandleRepositoryImpl(this.remote);

  @override
  Future<(List<CandleEntity>, int?)> getCandles({
    required String symbol,
    required String interval,
    int? endTime,
  }) async {
    return await remote.getCandles(
      symbol: symbol,
      interval: interval,
      endTime: endTime,
    );
  }
}
