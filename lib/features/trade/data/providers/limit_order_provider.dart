import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/limit_order/limit_order_request.dart';
import '../models/limit_order/limit_order_response.dart';
import '../repositories/limit_order_repository.dart';
import 'limit_open_order_provider.dart';
import 'order_calculation_provider.dart';

final limitOrderProvider =
NotifierProvider<LimitOrderNotifier, LimitOrderState>(
  LimitOrderNotifier.new,
);

class LimitOrderState {
  final bool isLoading;
  final LimitOrderResponse? response;
  final String? error;

  const LimitOrderState({
    this.isLoading = false,
    this.response,
    this.error,
  });

  LimitOrderState copyWith({
    bool? isLoading,
    LimitOrderResponse? response,
    String? error,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return LimitOrderState(
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

class LimitOrderNotifier extends Notifier<LimitOrderState> {
  late final LimitOrderRepository _repository;

  @override
  LimitOrderState build() {
    _repository = LimitOrderRepository();

    return const LimitOrderState();
  }

  Future<void> placeBuyOrder(
      String symbol,
      double price,
      ) async {
    await _placeOrder('BUY', symbol, price);
  }

  Future<void> placeSellOrder(
      String symbol,
      double price,
      ) async {
    await _placeOrder('SELL', symbol, price);
  }

  Future<void> _placeOrder(
      String side,
      String symbol,
      double price,
      ) async {
    final calculation = ref.read(orderCalculationProvider);

    if (price <= 0) {
      state = state.copyWith(
        error: 'Please enter limit price',
        clearResponse: true,
      );
      return;
    }

    if (calculation.amount <= 0) {
      state = state.copyWith(
        error: 'Please enter amount',
        clearResponse: true,
      );
      return;
    }

    if (calculation.leverage <= 0) {
      state = state.copyWith(
        error: 'Invalid leverage',
        clearResponse: true,
      );
      return;
    }

    double quantity;

    if (calculation.priceType == 'BTC') {
      quantity = calculation.amount;
    } else {
      quantity = calculation.amount / price;
    }

    if (quantity <= 0) {
      state = state.copyWith(
        error: 'Invalid quantity',
        clearResponse: true,
      );
      return;
    }

    final request = LimitOrderRequest(
      accountId: 'DEMO001',
      symbol: symbol,
      side: side,
      quantity: quantity,
      price: price,
      leverage: calculation.leverage,
      marginMode: 'ISOLATED',
      takeProfit: null,
      stopLoss: null,
    );

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearResponse: true,
    );

    try {
      final response =
      await _repository.placeLimitOrder(request);

      state = state.copyWith(
        isLoading: false,
        response: response,
      );
      await ref
          .read(limitOpenOrderProvider.notifier)
          .getOpenLimitOrders(request.accountId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}