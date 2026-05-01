import '../../entities/binance/pair_entity.dart';

abstract class BinanceRepository {
  Future<List<PairEntity>> getPairs();
}
