import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/market_remote_datasource.dart';
import '../data/repositories/market_repository_impl.dart';

final marketDataSourceProvider = Provider<MarketRemoteDataSource>((ref) {
  return MarketRemoteDataSource();
});

final marketRepositoryProvider = Provider<MarketRepositoryImpl>((ref) {
  return MarketRepositoryImpl(ref.read(marketDataSourceProvider));
});
