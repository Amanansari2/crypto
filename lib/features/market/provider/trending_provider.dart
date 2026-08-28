import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/market_response_model.dart';
import 'market_provider.dart';

final trendingProvider =
FutureProvider<MarketResponseModel>((ref) async {
  LogHelper.log("Trending provider called");
  final repository = ref.read(marketRepositoryProvider);
  final data =  await repository.getTrendingCoins();
  return data;
});