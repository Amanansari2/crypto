import 'package:crypto_app/features/market/domain/entities/market_entity.dart';

import '../repositories/market_repository.dart';

class GetAllCoins {
  final MarketRepository repository;

  GetAllCoins(this.repository);

  Future<MarketEntity> call({int page = 1}) {
    return repository.getAllCoins(page: page);
  }
}
