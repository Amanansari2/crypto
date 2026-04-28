import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/get_all_coins.dart';
import '../domain/usecases/get_gainers.dart';
import '../domain/usecases/get_losers.dart';
import '../domain/usecases/get_new_coins.dart';
import '../domain/usecases/get_trending_coins.dart';
import 'market_dependencies.dart';

final getTrendingCoinsProvider = Provider<GetTrendingCoins>((ref) {
  return GetTrendingCoins(ref.read(marketRepositoryProvider));
});

final getAllCoinsProvider = Provider<GetAllCoins>((ref) {
  return GetAllCoins(ref.read(marketRepositoryProvider));
});

final getGainersProvider = Provider<GetGainers>((ref) {
  return GetGainers(ref.read(marketRepositoryProvider));
});

final getLosersProvider = Provider<GetLosers>((ref) {
  return GetLosers(ref.read(marketRepositoryProvider));
});

final getNewCoinProvider = Provider<GetNewCoins>((ref) {
  return GetNewCoins(ref.read(marketRepositoryProvider));
});
