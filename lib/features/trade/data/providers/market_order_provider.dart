

import 'package:crypto_app/features/trade/data/providers/position/position_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/market_execuation/market_order_request.dart';
import '../models/market_execuation/market_order_response.dart';
import '../repositories/market_order_repository.dart';
import 'home_ticker_provider.dart';
import 'order_calculation_provider.dart';

final marketOrderProvider =
NotifierProvider<MarketOrderNotifier, MarketOrderState>(
  MarketOrderNotifier.new,
);

class MarketOrderState {
  final bool isLoading;
  final MarketOrderResponse? response;
  final String? error;

  const MarketOrderState({
    this.isLoading = false,
    this.response,
    this.error,
  });

  MarketOrderState copyWith({
    bool? isLoading,
    MarketOrderResponse? response,
    String? error,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return MarketOrderState(
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

class MarketOrderNotifier extends Notifier<MarketOrderState> {
  late final MarketOrderRepository _repository;

  @override
  MarketOrderState build() {
    _repository = MarketOrderRepository();

    return const MarketOrderState();
  }

  Future<void> placeBuyOrder(String symbol) async {
    await _placeOrder('BUY', symbol);
  }

  Future<void> placeSellOrder(String symbol) async {
    await _placeOrder('SELL', symbol);
  }

  Future<void> _placeOrder(String side, String symbol) async {
    final calculation = ref.read(orderCalculationProvider);
    final tickerAsync = ref.read(homeTickerProvider(symbol));

    if (!tickerAsync.hasValue) {
      state = state.copyWith(
        error: 'Market data is not available',
        clearResponse: true,
      );
      return;
    }

    final ticker = tickerAsync.requireValue;

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
      final executionPrice =
      side == 'BUY' ? ticker.ask : ticker.bid;

      if (executionPrice <= 0) {
        state = state.copyWith(
          error: 'Invalid market price',
          clearResponse: true,
        );
        return;
      }

      quantity = calculation.amount / executionPrice;
    }

    final request = MarketOrderRequest(
      accountId: 'DEMO001',
      symbol: symbol,
      side: side,
      quantity: quantity,
      leverage: calculation.leverage,
      marginMode: 'ISOLATED',
      reduceOnly: false,
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
      await _repository.placeMarketOrder(request);

      state = state.copyWith(
        isLoading: false,
        response: response,
      );
      await ref.read(positionProvider.notifier).getOpenPositions('DEMO001');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}