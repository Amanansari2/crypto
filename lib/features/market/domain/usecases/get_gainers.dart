import 'package:crypto_app/features/market/domain/entities/market_entity.dart';

import '../repositories/market_repository.dart';

class GetGainers {
  final MarketRepository repository;

  GetGainers(this.repository);

  Future<MarketEntity> call() {
    return repository.getGainers();
  }
}
