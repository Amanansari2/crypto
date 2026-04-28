import 'coin_entity.dart';

class MarketEntity {
  final List<CoinEntity> coins;
  final int currentPage;
  final bool hasMore;

  const MarketEntity({
    required this.coins,
    required this.currentPage,
    required this.hasMore,
  });
}
