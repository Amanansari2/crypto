import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/market_entity.dart';
import 'market_usecase.dart';

class NewCoinsNotifier extends AsyncNotifier<MarketEntity> {
  @override
  Future<MarketEntity> build() async {
    final usecase = ref.read(getNewCoinProvider);
    return usecase();
  }
}

final newCoinProvider = AsyncNotifierProvider<NewCoinsNotifier, MarketEntity>(
  NewCoinsNotifier.new,
);
