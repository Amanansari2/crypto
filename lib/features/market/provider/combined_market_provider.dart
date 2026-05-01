import 'package:crypto_app/features/market/provider/state/combined_market_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'binance/pair_provider.dart';
import 'market_provider.dart';

final combinedMarketProvider = FutureProvider<CombinedMarketState>((ref) async {
  final trendingData = await ref.watch(trendingCoinsProvider.future);

  final pairs = await ref.watch(binancePairsProvider.future);

  return CombinedMarketState(coins: trendingData.coins, pairs: pairs);
});
