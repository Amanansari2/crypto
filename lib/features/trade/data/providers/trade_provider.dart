import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/widgets/trade_constant/trade_constants.dart';
import '../models/distribution_row.dart';
import '../models/trade_state.dart';

final tradeHomeProvider =
    NotifierProvider<TradeHomeNotifier, TradeState>(
  TradeHomeNotifier.new,
);

class TradeHomeNotifier extends Notifier<TradeState> {

  @override
  TradeState build() {
    return  TradeState(
      isIsolated: true,
      leverage: 3,
      orderType: TradeConstants.orderTypes.first,
      bboType: TradeConstants.bboTypes.first,
      price: 0,
      amount: 0,
      sliderPercent: 0,
      reduceOnly: false,
      tpSl: false,
      advancedOrderType: TradeConstants.advancedOrderTypes.first,
      triggerPriceType: TradeConstants.triggerPriceTypes.first,
      triggerOrderType: TradeConstants.triggerOrderTypes.first,
      useBbo: false,
      selectedDistributionType: TradeConstants.distributionType.first,
      minPriceError: null,
      maxPriceError: null,
      subOrderError: null,
      amountError: null,
      canOpenDistribution: false,
      distributionRows: const [],
      isRatio:  false
    );
  }

  void setOrderType(String value) {
    state = state.copyWith(orderType: value);
  }

  void setBboType(String value) {
    state = state.copyWith(bboType: value);
  }



  void setSlider(double value) {
    state = state.copyWith(sliderPercent: value);
  }

  void setMarginMode(bool isolated) {
    state = state.copyWith(
      isIsolated: isolated,
    );
  }

  void increaseLeverage() {
    if (state.leverage < 150) {
      state = state.copyWith(
        leverage: state.leverage + 1,
      );
    }
  }

  void decreaseLeverage() {
    if (state.leverage > 1) {
      state = state.copyWith(
        leverage: state.leverage - 1,
      );
    }
  }

  void setLeverage(int value) {
    state = state.copyWith(
      leverage: value,
    );
  }

  void toggleReduceOnly() {
    state = state.copyWith(
      reduceOnly: !state.reduceOnly,
    );
  }

  void toggleTpSl() {
    state = state.copyWith(
      tpSl: !state.tpSl,
    );
  }

  void setAdvancedOrderType(String value) {
    state = state.copyWith(
      advancedOrderType: value,
    );
  }

  void setTriggerPriceType(String value) {
    state = state.copyWith(
      triggerPriceType: value,
    );
  }

  void setTriggerOrderType(String value) {
    state = state.copyWith(
      triggerOrderType: value,
    );
  }

  void toggleBbo() {
    state = state.copyWith(
      useBbo: !state.useBbo,
    );
  }

  void setDistributionType(String value) {
    state = state.copyWith(
      selectedDistributionType: value,
    );
  }

  void setRatio(bool value) {
    state = state.copyWith(isRatio: value);
  }

  void validateScaledOrder({
    required String minPriceText,
    required String maxPriceText,
    required String subOrderText,
    required String amountText,
  }) {
    final minPrice = double.tryParse(minPriceText);
    final maxPrice = double.tryParse(maxPriceText);
    final subOrder = int.tryParse(subOrderText);
    final amount = double.tryParse(amountText);

    String? minError;
    String? maxError;
    String? subError;
    String? amountError;

    bool canOpen = true;

    if (minPriceText.isEmpty) {
      minError = 'Minimum price is required';
      canOpen = false;
    } else if (minPrice == null || minPrice <= 0) {
      minError = 'Enter valid minimum price';
      canOpen = false;
    }

    if (maxPriceText.isEmpty) {
      maxError = 'Maximum price is required';
      canOpen = false;
    } else if (maxPrice == null || maxPrice <= 0) {
      maxError = 'Enter valid maximum price';
      canOpen = false;
    }

    if (minPrice != null &&
        maxPrice != null &&
        maxPrice <= minPrice) {
      maxError =
      'Maximum price must be greater than minimum price';
      canOpen = false;
    }

    if (subOrderText.isEmpty) {
      subError = 'Sub-order count is required';
      canOpen = false;
    } else if (subOrder == null ||
        subOrder < 2 ||
        subOrder > 60) {
      subError =
      'Sub-order count must be between 2 and 60';
      canOpen = false;
    }

    if (amountText.isEmpty) {
      amountError = 'Amount is required';
      canOpen = false;
    } else if (amount == null || amount <= 0) {
      amountError = 'Enter valid amount';
      canOpen = false;
    }

    state = state.copyWith(
      canOpenDistribution: canOpen,
      minPriceError: minError,
      maxPriceError: maxError,
      subOrderError: subError,
      amountError: amountError,
    );
  }

  void generateDistribution({
    required double minPrice,
    required double maxPrice,
    required int orderCount,
    required double totalAmount,
    required String distributionType,
    required bool isRatio,
  }) {
    if (orderCount < 2 ||
        orderCount > 60 ||
        maxPrice <= minPrice ||
        totalAmount <= 0) {
      return;
    }

    final rows = <DistributionRow>[];

    final priceStep =
        (maxPrice - minPrice) / (orderCount - 1);



    final weights = <double>[];

    switch (distributionType) {
      case 'Equal':
        for (int i = 0; i < orderCount; i++) {
          weights.add(1);
        }
        break;

      case 'Increasing':
        if (isRatio) {
          const ratio = 1.25;
          double value = 1;

          for (int i = 0; i < orderCount; i++) {
            weights.add(value);
            value *= ratio;
          }
        } else {
          for (int i = 0; i < orderCount; i++) {
            weights.add((i + 1).toDouble());
          }
        }
        break;

      case 'Decreasing':
        if (isRatio) {

          const ratio = 1.25;
          double value = pow(ratio, orderCount - 1).toDouble();

          for (int i = 0; i < orderCount; i++) {
            weights.add(value);
            value /= ratio;
          }
        } else {
          for (int i = 0; i < orderCount; i++) {
            weights.add(
              (orderCount - i).toDouble(),
            );
          }
        }
        break;

      case 'Random':
        final random = Random();

        for (int i = 0; i < orderCount; i++) {
          weights.add(
            random.nextDouble() + 0.1,
          );
        }
        break;
    }

    final totalWeight =
    weights.reduce((a, b) => a + b);

    for (int i = 0; i < orderCount; i++) {
      final price =
          minPrice + (priceStep * i);

      final amount =
          totalAmount *
              weights[i] /
              totalWeight;

      final percentage =
          (amount / totalAmount) * 100;

      rows.add(
        DistributionRow(
          price: price,
          amount: amount,
          percentage: percentage,
        ),
      );
    }

    state = state.copyWith(
      distributionRows: rows,
    );
  }
}