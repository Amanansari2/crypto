import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/market_response_model.dart';
import '../data/repositories/market_repository.dart';
import 'market_provider.dart';

class SearchNotifier extends AsyncNotifier<MarketResponseModel?> {
  late final MarketRepository _repository;

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  @override
  Future<MarketResponseModel?> build() async {
    _repository = ref.read(marketRepositoryProvider);
    return null;
  }

  Future<void> search(String query) async {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      state = const AsyncData(null);
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => _repository.getAllCoins(
        search: _searchQuery,
      ),
    );
  }
}

final searchProvider = AsyncNotifierProvider.autoDispose<
    SearchNotifier,
    MarketResponseModel?
>(
  SearchNotifier.new,
);