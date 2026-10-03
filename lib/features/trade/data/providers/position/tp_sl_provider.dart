import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/position/tp_sl_repository.dart';

final tpSlProvider =
NotifierProvider<TpSlNotifier, TpSlState>(
  TpSlNotifier.new,
);

class TpSlState {
  final bool isLoading;
  final Map<String, dynamic>? response;
  final String? error;

  const TpSlState({
    this.isLoading = false,
    this.response,
    this.error,
  });

  TpSlState copyWith({
    bool? isLoading,
    Map<String, dynamic>? response,
    String? error,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return TpSlState(
      isLoading: isLoading ?? this.isLoading,
      response: clearResponse
          ? null
          : response ?? this.response,
      error: clearError
          ? null
          : error ?? this.error,
    );
  }
}

class TpSlNotifier extends Notifier<TpSlState> {
  late final TpSlRepository _repository;

  @override
  TpSlState build() {
    _repository = TpSlRepository();
    return const TpSlState();
  }

  Future<void> updateTpSl({
    required String accountId,
    required String tradeId,
    double? takeProfit,
    double? stopLoss,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearResponse: true,
    );

    try {
      final response = await _repository.updateTpSl(
        accountId: accountId,
        tradeId: tradeId,
        takeProfit: takeProfit,
        stopLoss: stopLoss,
      );

      state = state.copyWith(
        isLoading: false,
        response: response,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clear() {
    state = const TpSlState();
  }
}