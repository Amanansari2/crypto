import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderCalculationProvider =
NotifierProvider<OrderCalculationNotifier, OrderCalculationState>(
  OrderCalculationNotifier.new,
);

class OrderCalculationState {
  final double amount;
  final double marketPrice;
  final double cost;
  final double notional;
  final double minimumAmount;
  final double minimumLotSize;
  final double maxAmount;
  final double sliderPercent;
  final double availableBalance;
  final int leverage;
  final String priceType;
  final double displayCost;


  const OrderCalculationState({
    this.amount = 0,
    this.marketPrice = 0,
    this.cost = 0,
    this.notional = 0,
    this.minimumAmount = 0,
    this.minimumLotSize = 0.0001,
    this.maxAmount = 0,
    this.sliderPercent = 0,
    this.availableBalance = 0,
    this.leverage = 1,
    this.priceType = 'USDT',
    this.displayCost = 0,
  });

  OrderCalculationState copyWith({
    double? amount,
    double? marketPrice,
    double? cost,
    double? notional,
    double? minimumAmount,
    double? minimumLotSize,
    double? maxAmount,
    double? sliderPercent,
    double? availableBalance,
    int? leverage,
    String? priceType,
    double? displayCost,
  }) {
    return OrderCalculationState(
      amount: amount ?? this.amount,
      marketPrice: marketPrice ?? this.marketPrice,
      cost: cost ?? this.cost,
      notional: notional ?? this.notional,
      minimumAmount: minimumAmount ?? this.minimumAmount,
      minimumLotSize: minimumLotSize ?? this.minimumLotSize,
      maxAmount: maxAmount ?? this.maxAmount,
      sliderPercent: sliderPercent ?? this.sliderPercent,
      availableBalance:
      availableBalance ?? this.availableBalance,
      leverage: leverage ?? this.leverage,
      priceType: priceType ?? this.priceType,
      displayCost: displayCost ?? this.displayCost,
    );
  }
}

class OrderCalculationNotifier
    extends Notifier<OrderCalculationState> {
  static const double minimumLotSize = 0.0001;

  @override
  OrderCalculationState build() {
    return const OrderCalculationState(
      minimumLotSize: minimumLotSize,
    );
  }

  void setAmount(double value) {
    state = state.copyWith(
      amount: value,
    );

    _calculate();
  }

  void setMarketPrice(double value) {
    state = state.copyWith(
      marketPrice: value,
    );

    _calculate();
  }

  void setPriceType(String value) {
    state = state.copyWith(
      priceType: value,
    );

    _calculate();
  }

  void setLeverage(int value) {
    state = state.copyWith(
      leverage: value,
    );

    _calculate();
  }

  void setAvailableBalance(double value) {
    state = state.copyWith(
      availableBalance: value,
    );

    _calculateMaxAmount();
  }

  void setSlider(double value) {
    final amount =
        state.maxAmount * (value / 100);

    state = state.copyWith(
      sliderPercent: value,
      amount: amount,
    );

    _calculate();
  }

  void _calculate() {
    final amount = state.amount;
    final leverage = state.leverage;
    final marketPrice = state.marketPrice;
    final priceType = state.priceType;

    double notional = 0;
    double cost = 0;

    if (priceType == 'USDT') {
      notional = amount;
    } else {
      notional = amount * marketPrice;
    }

    if (leverage > 0) {
      cost = notional / leverage;
    }

    final displayCost =
        (cost * 100).floor() / 100;

    final minimumAmount =
        marketPrice * state.minimumLotSize;

    state = state.copyWith(
      notional: notional,
      cost: cost,
      displayCost: displayCost,
      minimumAmount: minimumAmount,
    );

    _calculateMaxAmount();
  }

  void _calculateMaxAmount() {
    final maxAmount =
        state.availableBalance * state.leverage;

    double sliderPercent = 0;

    if (maxAmount > 0 && state.amount > 0) {
      sliderPercent =
          (state.amount / maxAmount * 100)
              .clamp(0, 100)
              .toDouble();
    }

    state = state.copyWith(
      maxAmount: maxAmount,
      sliderPercent: sliderPercent,
    );
  }

  void clear() {
    state = const OrderCalculationState(
      minimumLotSize: minimumLotSize,
    );
  }
}