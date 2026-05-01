import '../../domain/entities/binance/pair_entity.dart';
import '../../domain/entities/coin_entity.dart';

class CombinedMarketState {
  final List<CoinEntity> coins;
  final List<PairEntity> pairs;

  CombinedMarketState({required this.coins, required this.pairs});
}
