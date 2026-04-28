import 'package:crypto_app/features/market/data/models/coin_model.dart';
import 'package:crypto_app/features/market/data/models/market_response_model.dart';
import 'package:crypto_app/features/market/domain/entities/market_entity.dart';

import '../../domain/repositories/market_repository.dart';
import '../datasources/market_remote_datasource.dart';

class MarketRepositoryImpl implements MarketRepository {
  final MarketRemoteDataSource remote;

  MarketRepositoryImpl(this.remote);

  Future<MarketEntity> _getCoins(
    Future<MarketResponseModel> Function() call,
  ) async {
    final response = await call();
    return MarketEntity(
      coins: response.coins.map((e) => e.toEntity()).toList(),
      currentPage: response.currentPage,
      hasMore: response.hasMore,
    );
  }

  @override
  Future<MarketEntity> getTrending() => _getCoins(() => remote.getTrending());

  @override
  Future<MarketEntity> getGainers() => _getCoins(() => remote.getGainers());

  @override
  Future<MarketEntity> getLosers() => _getCoins(() => remote.getLosers());

  @override
  Future<MarketEntity> getAllCoins({int page = 1}) =>
      _getCoins(() => remote.getAllCoins(page: page));

  @override
  Future<MarketEntity> getNewCoins() => _getCoins(() => remote.getNewCoins());
}
