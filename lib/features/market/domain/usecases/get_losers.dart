import 'package:crypto_app/features/market/domain/entities/market_entity.dart';

import '../repositories/market_repository.dart';

class GetLosers {
  final MarketRepository repository;

  GetLosers(this.repository);

  Future<MarketEntity> call() {
    return repository.getLosers();
  }
}
