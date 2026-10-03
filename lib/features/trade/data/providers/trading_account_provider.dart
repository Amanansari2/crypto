import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/trading_account_model.dart';
import '../repositories/trading_account_repository.dart';

final tradingAccountProvider =
NotifierProvider<TradingAccountNotifier, TradingAccountState>(
  TradingAccountNotifier.new,
);

class TradingAccountState {
  final bool isLoading;
  final TradingAccountModel? account;
  final String? error;

  const TradingAccountState({
    this.isLoading = false,
    this.account,
    this.error,
  });

  TradingAccountState copyWith({
    bool? isLoading,
    TradingAccountModel? account,
    String? error,
    bool clearAccount = false,
    bool clearError = false,
  }) {
    return TradingAccountState(
      isLoading: isLoading ?? this.isLoading,
      account: clearAccount ? null : account ?? this.account,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class TradingAccountNotifier
    extends Notifier<TradingAccountState> {
  late final TradingAccountRepository _repository;

  @override
  TradingAccountState build() {
    _repository = TradingAccountRepository();

    return const TradingAccountState();
  }

  Future<void> getTradingAccount(
      String accountId,
      ) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearAccount: true,
    );

    try {
      final account =
      await _repository.getTradingAccount(accountId);

      state = state.copyWith(
        isLoading: false,
        account: account,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clear() {
    state = const TradingAccountState();
  }
}