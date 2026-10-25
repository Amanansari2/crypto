
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/wallet_overview_model.dart';
import '../repository/wallet_repository.dart';

final walletOverviewProvider =
NotifierProvider<WalletOverviewNotifier, WalletOverviewState>(
  WalletOverviewNotifier.new,
);

class WalletOverviewState {
  final bool isLoading;
  final WalletOverviewModel? wallet;
  final String? error;

  const WalletOverviewState({
    this.isLoading = false,
    this.wallet,
    this.error,
  });

  WalletOverviewState copyWith({
    bool? isLoading,
    WalletOverviewModel? wallet,
    String? error,
    bool clearError = false,
  }) {
    return WalletOverviewState(
      isLoading: isLoading ?? this.isLoading,
      wallet: wallet ?? this.wallet,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class WalletOverviewNotifier extends Notifier<WalletOverviewState> {
  late final WalletRepository _repository;
  String? _accountId;

  @override
  WalletOverviewState build() {
    _repository = WalletRepository();
    return const WalletOverviewState();
  }

  Future<void> getWalletOverview(
      String accountId, {
        bool refresh = false,
      }) async {
    if (state.isLoading) return;

    if (!refresh &&
        _accountId == accountId &&
        state.wallet != null) {
      return;
    }

    _accountId = accountId;

    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final wallet = await _repository.getWalletOverview(
        accountId: accountId,
      );

      state = state.copyWith(
        isLoading: false,
        wallet: wallet,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh(String accountId) async {
    await getWalletOverview(accountId, refresh: true);
  }

  void clear() {
    _accountId = null;
    state = const WalletOverviewState();
  }
}
