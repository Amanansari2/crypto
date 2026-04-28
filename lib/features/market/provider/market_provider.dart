import 'package:crypto_app/features/market/domain/entities/market_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'all_coin_notifier.dart';
import 'gainers_notifier.dart';
import 'loser_notifier.dart';
import 'market_usecase.dart';
import 'new_coin_notifier.dart';

final trendingCoinsProvider = FutureProvider<MarketEntity>((ref) async {
  final usecase = ref.read(getTrendingCoinsProvider);
  return usecase();
});

final allCoinsProvider = AsyncNotifierProvider<CoinsNotifier, MarketEntity>(
  CoinsNotifier.new,
);

final gainersProvider = AsyncNotifierProvider<GainersNotifier, MarketEntity>(
  GainersNotifier.new,
);

final losersProvider = AsyncNotifierProvider<LosersNotifier, MarketEntity>(
  LosersNotifier.new,
);

final newCoinProvider = AsyncNotifierProvider<NewCoinsNotifier, MarketEntity>(
  NewCoinsNotifier.new,
);
