
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/websocket/trading_backend_socket_service.dart';
import '../models/limit_order/limit_open_order.dart';
import '../repositories/limit_open_order_repository.dart';

final limitOpenOrderProvider =
NotifierProvider<LimitOpenOrderNotifier, LimitOpenOrderState>(
  LimitOpenOrderNotifier.new,
);

class LimitOpenOrderState {
  final bool isLoading;
  final List<LimitOpenOrder> orders;
  final String? error;

  const LimitOpenOrderState({
    this.isLoading = false,
    this.orders = const [],
    this.error,
  });

  LimitOpenOrderState copyWith({
    bool? isLoading,
    List<LimitOpenOrder>? orders,
    String? error,
    bool clearOrders = false,
    bool clearError = false,
  }) {
    return LimitOpenOrderState(
      isLoading: isLoading ?? this.isLoading,
      orders: clearOrders ? [] : orders ?? this.orders,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class LimitOpenOrderNotifier extends Notifier<LimitOpenOrderState> {
  late final LimitOpenOrderRepository _repository;
  final TradingBackendSocketService _socket = TradingBackendSocketService();

  StreamSubscription<Map<String, dynamic>>? _limitOrderFilledSubscription;

  String? _listeningAccountId;

  @override
  LimitOpenOrderState build() {
    _repository = LimitOpenOrderRepository();
    ref.onDispose(() {
      _limitOrderFilledSubscription?.cancel();
      _limitOrderFilledSubscription = null;
      _listeningAccountId = null;
    });

    return const LimitOpenOrderState();
  }

  Future<void> getOpenLimitOrders(String accountId) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final orders =
      await _repository.getOpenLimitOrders(accountId);

      state = state.copyWith(
        isLoading: false,
        orders: orders,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void listenLimitOrderFilled(String accountId) {
    final normalizedAccountId = accountId.trim();

    if (normalizedAccountId.isEmpty) return;

    if (_listeningAccountId == normalizedAccountId &&
        _limitOrderFilledSubscription != null) {
      return;
    }

    _limitOrderFilledSubscription?.cancel();

    _listeningAccountId = normalizedAccountId;

    _limitOrderFilledSubscription = _socket.messages
        .where(
          (message) =>
      message['type'] == 'LIMIT_ORDER_FILLED' &&
          message['accountId']?.toString() ==
              normalizedAccountId,
    )
        .listen((message) {
      getOpenLimitOrders(normalizedAccountId);
    });
  }


  void clear() {
    state = const LimitOpenOrderState();
  }
}
