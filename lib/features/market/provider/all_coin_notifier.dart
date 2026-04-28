import 'package:crypto_app/features/market/provider/market_dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/market_entity.dart';
import 'market_usecase.dart';

class CoinsNotifier extends AsyncNotifier<MarketEntity> {
  int _page = 1;
  bool _isLoading = false;

  @override
  Future<MarketEntity> build() async {
    final usecase = ref.read(getAllCoinsProvider);
    return await usecase(page: _page);
  }

  Future<void> loadMore() async {
    if (_isLoading) return;

    final current = state.value;
    if (current == null || !current.hasMore) return;
    _isLoading = true;
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      _page++;
      final usecase = ref.read(getAllCoinsProvider);
      final next = await usecase(page: _page);
      state = AsyncData(
        MarketEntity(
          coins: [...current.coins, ...next.coins],
          currentPage: next.currentPage,
          hasMore: next.hasMore,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refresh() async {
    try {
      _page = 1;
      ref.read(marketDataSourceProvider).clearCache();
      state = const AsyncLoading();
      final usecase = ref.read(getAllCoinsProvider);
      final data = await usecase(page: _page);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final allCoinsProvider = AsyncNotifierProvider<CoinsNotifier, MarketEntity>(
  CoinsNotifier.new,
);
