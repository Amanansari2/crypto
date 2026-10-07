import 'dart:async';

import 'package:crypto_app/core/network/websocket/trading_backend_socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/position/position_model.dart';
import '../../repositories/position/position_repository.dart';

final positionProvider =
NotifierProvider<PositionNotifier, PositionState>(
  PositionNotifier.new,
);

class PositionState {
  final bool isLoading;
  final List<PositionModel> positions;
  final String? error;

  const PositionState({
    this.isLoading = false,
    this.positions = const [],
    this.error,
  });

  PositionState copyWith({
    bool? isLoading,
    List<PositionModel>? positions,
    String? error,
    bool clearPositions = false,
    bool clearError = false,
  }) {
    return PositionState(
      isLoading: isLoading ?? this.isLoading,
      positions: clearPositions ? [] : positions ?? this.positions,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class PositionNotifier extends Notifier<PositionState> {
  late final PositionRepository _repository;
  String? _listeningAccountId;

  final TradingBackendSocketService _socket = TradingBackendSocketService();


  StreamSubscription<Map<String, dynamic>>? _positionClosedSubscription;

  @override
  PositionState build() {
    _repository = PositionRepository();

    ref.onDispose(() {
      _positionClosedSubscription?.cancel();
      _positionClosedSubscription = null;
      _listeningAccountId = null;
    });

    return const PositionState();
  }

  Future<void> getOpenPositions(
      String accountId,
      ) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearPositions: true,
    );

    try {
      final positions =
      await _repository.getOpenPositions(accountId);

      state = state.copyWith(
        isLoading: false,
        positions: positions,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void listenPositionClosed(String accountId) {
    final normalizedAccountId = accountId.trim();

    // Already listening for this account.
    if (_listeningAccountId == normalizedAccountId &&
        _positionClosedSubscription != null) {
      return;
    }

    _positionClosedSubscription?.cancel();

    _listeningAccountId = normalizedAccountId;

    _positionClosedSubscription = _socket.messages
        .where(
          (message) =>
      message['type'] == 'POSITION_CLOSED' &&
          message['accountId']?.toString() ==
              normalizedAccountId,
    )
        .listen((message) {
      getOpenPositions(normalizedAccountId);
    });
  }


  void clear() {
    state = const PositionState();
  }
}