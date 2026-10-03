import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/position/position_close_repository.dart';

final positionCloseProvider =
NotifierProvider<PositionCloseNotifier, PositionCloseState>(
  PositionCloseNotifier.new,
);

class PositionCloseState {
  final bool isLoading;
  final Map<String, dynamic>? response;
  final String? error;

  const PositionCloseState({
    this.isLoading = false,
    this.response,
    this.error,
  });

  PositionCloseState copyWith({
    bool? isLoading,
    Map<String, dynamic>? response,
    String? error,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return PositionCloseState(
      isLoading: isLoading ?? this.isLoading,
      response: clearResponse ? null : response ?? this.response,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class PositionCloseNotifier
    extends Notifier<PositionCloseState> {
  late final PositionCloseRepository _repository;

  @override
  PositionCloseState build() {
    _repository = PositionCloseRepository();
    return const PositionCloseState();
  }

  Future<void> closePosition({
    required String accountId,
    required String tradeId,
    required String symbol,
    required String side,
    required double quantity,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearResponse: true,
    );

    try {
      final response = await _repository.closePosition(
        accountId: accountId,
        tradeId: tradeId,
        symbol: symbol,
        side: side,
        quantity: quantity,
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
    state = const PositionCloseState();
  }
}