
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/wallet_trade__history_model.dart';
import '../repository/wallet_repository.dart';

final walletTradeHistoryProvider = NotifierProvider<
    WalletTradeHistoryNotifier,
    WalletTradeHistoryState>(
  WalletTradeHistoryNotifier.new,
);

class WalletTradeHistoryState {
  final List<WalletTradeModel> trades;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int limit;
  final int offset;
  final int total;
  final bool hasMore;

  const WalletTradeHistoryState({
    this.trades = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.limit = 20,
    this.offset = 0,
    this.total = 0,
    this.hasMore = true,
  });

  WalletTradeHistoryState copyWith({
    List<WalletTradeModel>? trades,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
    int? offset,
    int? total,
    bool? hasMore,
  }) {
    return WalletTradeHistoryState(
      trades: trades ?? this.trades,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error ?? this.error,
      limit: limit,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class WalletTradeHistoryNotifier
    extends Notifier<WalletTradeHistoryState> {
  late final WalletRepository _repository;
  String? _accountId;

  @override
  WalletTradeHistoryState build() {
    _repository = WalletRepository();
    return const WalletTradeHistoryState();
  }

  Future<void> loadTrades(
      String accountId, {
        bool refresh = false,
      }) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (!refresh &&
        _accountId == accountId &&
        state.trades.isNotEmpty) {
      return;
    }

    _accountId = accountId;

    state = state.copyWith(
      isLoading: true,
      trades: refresh ? [] : state.trades,
      offset: refresh ? 0 : state.offset,
      total: refresh ? 0 : state.total,
      hasMore: refresh ? true : state.hasMore,
      clearError: true,
    );

    try {
      final response = await _repository.getWalletTrades(
        accountId: accountId,
        limit: state.limit,
        offset: 0,
      );

      state = state.copyWith(
        trades: response.trades,
        isLoading: false,
        offset: response.pagination.nextOffset,
        total: response.pagination.total,
        hasMore: response.pagination.hasMore,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (_accountId == null ||
        state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    state = state.copyWith(
      isLoadingMore: true,
      clearError: true,
    );

    try {
      final response = await _repository.getWalletTrades(
        accountId: _accountId!,
        limit: state.limit,
        offset: state.offset,
      );

      state = state.copyWith(
        trades: [
          ...state.trades,
          ...response.trades,
        ],
        isLoadingMore: false,
        offset: response.pagination.nextOffset,
        total: response.pagination.total,
        hasMore: response.pagination.hasMore,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh(String accountId) async {
    await loadTrades(accountId, refresh: true);
  }

  void clear() {
    _accountId = null;
    state = const WalletTradeHistoryState();
  }
}
