import 'distribution_row.dart';

class TradeState {
  final bool isIsolated;
  final int leverage;

  final String orderType;
  final String bboType;

  final double price;
  final double amount;

  final double sliderPercent;

  final bool reduceOnly;
  final bool tpSl;

  final String advancedOrderType;
  final String triggerPriceType;
  final String triggerOrderType;
  final bool useBbo;

  final bool canOpenDistribution;
  final List<DistributionRow> distributionRows;
  final String selectedDistributionType;
  final String? minPriceError;
  final String? maxPriceError;
  final String? subOrderError;
  final String? amountError;
  final bool isRatio;

  const TradeState({
    required this.isIsolated,
    required this.leverage,
    required this.orderType,
    required this.bboType,
    required this.price,
    required this.amount,
    required this.sliderPercent,
    required this.reduceOnly,
    required this.tpSl,
    required this.advancedOrderType,
    required this.triggerPriceType,
    required this.triggerOrderType,
    required this.useBbo,
    required this.canOpenDistribution,
    required this.distributionRows,
    required this.selectedDistributionType,
    required this.minPriceError,
    required this.maxPriceError,
    required this.subOrderError,
    required this.amountError,
    required this.isRatio
  });

  TradeState copyWith({
    bool? isIsolated,
    int? leverage,
    String? orderType,
    String? bboType,
    double? price,
    double? amount,
    double? sliderPercent,
    bool? reduceOnly,
    bool? tpSl,
    String? advancedOrderType,
    String? triggerPriceType,
    String? triggerOrderType,
    bool? useBbo,
    bool? canOpenDistribution,
    List<DistributionRow>? distributionRows,
    String? selectedDistributionType,
    String? minPriceError,
    String? maxPriceError,
    String? subOrderError,
    String? amountError,
    bool? isRatio
  }) {
    return TradeState(
      isIsolated: isIsolated ?? this.isIsolated,
      leverage: leverage ?? this.leverage,
      orderType: orderType ?? this.orderType,
      bboType: bboType ?? this.bboType,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      sliderPercent: sliderPercent ?? this.sliderPercent,
      reduceOnly: reduceOnly ?? this.reduceOnly,
      tpSl: tpSl ?? this.tpSl,
      advancedOrderType: advancedOrderType ?? this.advancedOrderType,
      triggerPriceType: triggerPriceType ?? this.triggerPriceType,
      triggerOrderType: triggerOrderType ?? this.triggerOrderType,
      useBbo: useBbo ?? this.useBbo,
      canOpenDistribution: canOpenDistribution ?? this.canOpenDistribution,
      distributionRows: distributionRows ?? this.distributionRows,
      selectedDistributionType:
          selectedDistributionType ?? this.selectedDistributionType,
      minPriceError: minPriceError,
      maxPriceError: maxPriceError,
      subOrderError: subOrderError,
      amountError: amountError,
      isRatio : isRatio ?? this.isRatio
    );
  }
}
