import '../../entities/binance/pair_entity.dart';
import '../../repositories/binance/binance_repository.dart';

class GetBinancePairs {
  final BinanceRepository repository;

  GetBinancePairs(this.repository);

  Future<List<PairEntity>> call() async {
    return await repository.getPairs();
  }
}
