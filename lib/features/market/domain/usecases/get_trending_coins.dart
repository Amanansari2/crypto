import 'package:crypto_app/features/market/domain/entities/market_entity.dart';

import '../repositories/market_repository.dart';

class GetTrendingCoins {
  final MarketRepository repository;

  GetTrendingCoins(this.repository);

  Future<MarketEntity> call() {
    return repository.getTrending();
  }
}
