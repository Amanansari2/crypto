import 'package:crypto_app/features/market/domain/entities/market_entity.dart';

import '../repositories/market_repository.dart';

class GetNewCoins {
  final MarketRepository repository;

  GetNewCoins(this.repository);

  Future<MarketEntity> call() {
    return repository.getNewCoins();
  }
}
