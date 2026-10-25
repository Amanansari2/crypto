
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/wallet_transaction_model.dart';
import '../repository/wallet_repository.dart';

final walletTransactionsProvider = NotifierProvider<
    WalletTransactionsNotifier,
    WalletTransactionsState>(
  WalletTransactionsNotifier.new,
);

class WalletTransactionsState {
  final List<WalletTransactionItemModel> transactions;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int limit;
  final int offset;
  final int total;
  final bool hasMore;

  const WalletTransactionsState({
    this.transactions = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.limit = 20,
    this.offset = 0,
    this.total = 0,
    this.hasMore = true,
  });

  WalletTransactionsState copyWith({
    List<WalletTransactionItemModel>? transactions,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
    int? limit,
    int? offset,
    int? total,
    bool? hasMore,
  }) {
    return WalletTransactionsState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error ?? this.error,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class WalletTransactionsNotifier
    extends Notifier<WalletTransactionsState> {
  late final WalletRepository _repository;
  String? _accountId;

  @override
  WalletTransactionsState build() {
    _repository = WalletRepository();
    return const WalletTransactionsState();
  }

  Future<void> loadTransactions(
      String accountId, {
        bool refresh = false,
      }) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (!refresh &&
        _accountId == accountId &&
        state.transactions.isNotEmpty) {
      return;
    }

    _accountId = accountId;

    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      transactions: refresh ? [] : state.transactions,
      offset: refresh ? 0 : state.offset,
      total: refresh ? 0 : state.total,
      hasMore: refresh ? true : state.hasMore,
      clearError: true,
    );

    try {
    final response = await _repository.getWalletTransactions(
    accountId: accountId,
    limit: state.limit,
    offset: 0,
    );

    state = state.copyWith(
    transactions: response.transactions,
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
      final response = await _repository.getWalletTransactions(
        accountId: _accountId!,
        limit: state.limit,
        offset: state.offset,
      );

      state = state.copyWith(
        transactions: [
          ...state.transactions,
          ...response.transactions,
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
    state = state.copyWith(
      transactions: [],
      offset: 0,
      total: 0,
      hasMore: true,
      clearError: true,
    );

    await loadTransactions(accountId, refresh: true);
  }

  void clear() {
    _accountId = null;
    state = const WalletTransactionsState();
  }
}
