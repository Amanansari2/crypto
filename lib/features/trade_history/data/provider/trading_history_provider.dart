import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/trading_history_model.dart';
import '../repository/trading_history_repository.dart';

final tradingHistoryProvider =
    NotifierProvider<TradingHistoryNotifier, TradingHistoryState>(
      TradingHistoryNotifier.new,
    );

class TradingHistoryState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<TradingHistoryModel> trades;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final String? error;

  const TradingHistoryState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.trades = const [],
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 0,
    this.error,
  });

  bool get hasMore => page < totalPages;

  TradingHistoryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<TradingHistoryModel>? trades,
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    String? error,
    bool clearError = false,
  }) {
    return TradingHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      trades: trades ?? this.trades,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class TradingHistoryNotifier extends Notifier<TradingHistoryState> {
  late final TradingHistoryRepository _repository;
  String? _accountId;

  @override
  TradingHistoryState build() {
    _repository = TradingHistoryRepository();
    return const TradingHistoryState();
  }

  Future<void> getTradingHistory(
    String accountId, {
    bool refresh = false,
  }) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (!refresh &&
        _accountId == accountId &&
        state.trades.isNotEmpty &&
        !state.hasMore) {
      return;
    }

    final requestedPage =
        refresh || _accountId != accountId || state.trades.isEmpty
        ? 1
        : state.page + 1;

    _accountId = accountId;

    if (requestedPage == 1) {
      state = state.copyWith(
        isLoading: true,
        trades: [],
        page: 1,
        total: 0,
        totalPages: 0,
        clearError: true,
      );
    } else {
      state = state.copyWith(isLoadingMore: true, clearError: true);
    }

    try {
      final response = await _repository.getTradingHistory(
        accountId: accountId,
        page: requestedPage,
        limit: state.limit,
      );

      final updatedTrades = requestedPage == 1
          ? response.trades
          : [...state.trades, ...response.trades];

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        trades: updatedTrades,
        page: response.pagination.page,
        limit: response.pagination.limit,
        total: response.pagination.total,
        totalPages: response.pagination.totalPages,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh(String accountId) async {
    await getTradingHistory(accountId, refresh: true);
  }

  void clear() {
    _accountId = null;
    state = const TradingHistoryState();
  }
}
