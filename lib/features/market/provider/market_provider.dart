import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/market_response_model.dart';
import '../data/repositories/market_repository.dart';
import '../enum/market_type.dart';

final marketRepositoryProvider = Provider<MarketRepository>(
      (ref) => MarketRepository(),
);

final marketProvider =
AsyncNotifierProvider<MarketNotifier, MarketResponseModel>(
  MarketNotifier.new,
);

class MarketNotifier extends AsyncNotifier<MarketResponseModel> {
  late final MarketRepository _repository;

  MarketType _currentType = MarketType.all;
  bool _isLoadingMore = false;

  @override
  Future<MarketResponseModel> build() async {
    _repository = ref.read(marketRepositoryProvider);
    _currentType = MarketType.all;
    return _repository.getAllCoins();
  }

  Future<void> loadAll() async {
    _currentType = MarketType.all;
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => _repository.getAllCoins(),
    );
  }

  Future<void> loadGainers() async {
    LogHelper.log("Load gainers");
    _currentType = MarketType.gainers;

    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => _repository.getGainersCoins(),
    );
  }

  Future<void> loadLosers() async {
    _currentType = MarketType.losers;

    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => _repository.getLosersCoins(),
    );
  }

  Future<void> loadNewCoins() async {
    _currentType = MarketType.newCoins;

    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => _repository.getNewCoins(),
    );
  }

  Future<void> refresh() async {
    switch (_currentType) {
      case MarketType.all:
        return loadAll();

      case MarketType.gainers:
        return loadGainers();

      case MarketType.losers:
        return loadLosers();

      case MarketType.newCoins:
        return loadNewCoins();
    // case MarketType.trending:
    //   return;
    }
  }

  Future<void> loadMore() async {
    if (_currentType != MarketType.all) return;
    if (_isLoadingMore) return;

    final current = state.value;

    if (current == null) return;
    if (!current.hasMore) return;

    _isLoadingMore = true;

    try {
      final response = await _repository.getAllCoins(
        page: current.currentPage + 1,
      );

      state = AsyncData(
        current.copyWith(
          coins: [
            ...current.coins,
            ...response.coins,
          ],
          currentPage: response.currentPage,
          hasMore: response.hasMore,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}