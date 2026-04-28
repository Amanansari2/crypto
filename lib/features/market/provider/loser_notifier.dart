import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/market_entity.dart';
import 'market_usecase.dart';

class LosersNotifier extends AsyncNotifier<MarketEntity> {
  @override
  Future<MarketEntity> build() async {
    final usecase = ref.read(getLosersProvider);
    return usecase();
  }
}

final losersProvider = AsyncNotifierProvider<LosersNotifier, MarketEntity>(
  LosersNotifier.new,
);
