import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/market_entity.dart';
import 'market_usecase.dart';

class GainersNotifier extends AsyncNotifier<MarketEntity> {
  @override
  Future<MarketEntity> build() async {
    final usecase = ref.read(getGainersProvider);
    return usecase();
  }
}

final gainersProvider = AsyncNotifierProvider<GainersNotifier, MarketEntity>(
  GainersNotifier.new,
);
