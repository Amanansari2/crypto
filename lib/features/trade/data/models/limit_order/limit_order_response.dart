class LimitOrderResponse {
  final bool success;
  final String message;
  final LimitOrderData order;
  final LimitOrderReservation reservation;
  final LimitOrderAccount account;

  const LimitOrderResponse({
    required this.success,
    required this.message,
    required this.order,
    required this.reservation,
    required this.account,
  });

  factory LimitOrderResponse.fromJson(Map<String, dynamic> json) {


    return LimitOrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      order: LimitOrderData.fromJson(json['order']),
      reservation: LimitOrderReservation.fromJson(json['reservation']),
      account: LimitOrderAccount.fromJson(json['account']),
    );


  }
}

class LimitOrderData {
  final int id;
  final String tradeId;
  final String accountId;
  final String symbol;
  final String side;
  final String positionSide;
  final String orderType;
  final double quantity;
  final double price;
  final int leverage;
  final String marginMode;
  final bool reduceOnly;
  final double? takeProfit;
  final double? stopLoss;
  final String status;
  final double filledQuantity;
  final double? averagePrice;
  final double fee;

  const LimitOrderData({
    required this.id,
    required this.tradeId,
    required this.accountId,
    required this.symbol,
    required this.side,
    required this.positionSide,
    required this.orderType,
    required this.quantity,
    required this.price,
    required this.leverage,
    required this.marginMode,
    required this.reduceOnly,
    required this.takeProfit,
    required this.stopLoss,
    required this.status,
    required this.filledQuantity,
    required this.averagePrice,
    required this.fee,
  });

  factory LimitOrderData.fromJson(Map<String, dynamic> json) {
    return LimitOrderData(
      id: json['id'],
      tradeId: json['tradeId'],
      accountId: json['accountId'],
      symbol: json['symbol'],
      side: json['side'],
      positionSide: json['positionSide'],
      orderType: json['orderType'],
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      leverage: (json['leverage'] as num).toInt(),
      marginMode: json['marginMode'],
      reduceOnly: json['reduceOnly'] as bool,
      takeProfit: (json['takeProfit'] as num?)?.toDouble(),
      stopLoss: (json['stopLoss'] as num?)?.toDouble(),
      status: json['status'],
      filledQuantity: (json['filledQuantity'] as num).toDouble(),
      averagePrice: (json['averagePrice'] as num?)?.toDouble(),
      fee: (json['fee'] as num).toDouble(),
    );
  }
}

class LimitOrderReservation {
  final double notional;
  final double margin;
  final double fee;
  final double totalRequired;

  const LimitOrderReservation({
    required this.notional,
    required this.margin,
    required this.fee,
    required this.totalRequired,
  });

  factory LimitOrderReservation.fromJson(Map<String, dynamic> json) {
    return LimitOrderReservation(
      notional: (json['notional'] as num).toDouble(),
      margin: (json['margin'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      totalRequired: (json['totalRequired'] as num).toDouble(),
    );
  }
}

class LimitOrderAccount {
  final double balance;
  final double availableBalance;
  final double usedMargin;
  final double totalFees;

  const LimitOrderAccount({
    required this.balance,
    required this.availableBalance,
    required this.usedMargin,
    required this.totalFees,
  });

  factory LimitOrderAccount.fromJson(Map<String, dynamic> json) {
    return LimitOrderAccount(
      balance: (json['balance'] as num).toDouble(),
      availableBalance: (json['availableBalance'] as num).toDouble(),
      usedMargin: (json['usedMargin'] as num).toDouble(),
      totalFees: (json['totalFees'] as num).toDouble(),
    );
  }
}