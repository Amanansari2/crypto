import 'package:crypto_app/features/market/domain/entities/market_entity.dart';

abstract class MarketRepository {
  Future<MarketEntity> getTrending();

  Future<MarketEntity> getGainers();

  Future<MarketEntity> getLosers();

  Future<MarketEntity> getAllCoins({int page});

  Future<MarketEntity> getNewCoins();
}
