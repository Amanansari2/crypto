class MarketOrderResponse {
  final bool success;
  final MarketOrderData order;
  final MarketOrderFill fill;
  final MarketOrderPosition position;
  final MarketOrderAccount account;

  const MarketOrderResponse({
    required this.success,
    required this.order,
    required this.fill,
    required this.position,
    required this.account,
  });

  factory MarketOrderResponse.fromJson(Map<String, dynamic> json) {
    return MarketOrderResponse(
      success: json['success'] as bool,
      order: MarketOrderData.fromJson(json['order']),
      fill: MarketOrderFill.fromJson(json['fill']),
      position: MarketOrderPosition.fromJson(json['position']),
      account: MarketOrderAccount.fromJson(json['account']),
    );
  }
}

class MarketOrderData {
  final int id;
  final String tradeId;
  final String accountId;
  final String symbol;
  final String side;
  final String positionSide;
  final String orderType;
  final double quantity;
  final double executionPrice;
  final int leverage;
  final String marginMode;
  final double margin;
  final double notional;
  final double fee;
  final String status;

  const MarketOrderData({
    required this.id,
    required this.tradeId,
    required this.accountId,
    required this.symbol,
    required this.side,
    required this.positionSide,
    required this.orderType,
    required this.quantity,
    required this.executionPrice,
    required this.leverage,
    required this.marginMode,
    required this.margin,
    required this.notional,
    required this.fee,
    required this.status,
  });

  factory MarketOrderData.fromJson(Map<String, dynamic> json) {
    return MarketOrderData(
      id: json['id'],
      tradeId: json['tradeId'],
      accountId: json['accountId'],
      symbol: json['symbol'],
      side: json['side'],
      positionSide: json['positionSide'],
      orderType: json['orderType'],
      quantity: (json['quantity'] as num).toDouble(),
      executionPrice: (json['executionPrice'] as num).toDouble(),
      leverage: (json['leverage'] as num).toInt(),
      marginMode: json['marginMode'],
      margin: (json['margin'] as num).toDouble(),
      notional: (json['notional'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      status: json['status'],
    );
  }
}

class MarketOrderFill {
  final int id;
  final double quantity;
  final double price;
  final double fee;

  const MarketOrderFill({
    required this.id,
    required this.quantity,
    required this.price,
    required this.fee,
  });

  factory MarketOrderFill.fromJson(Map<String, dynamic> json) {
    return MarketOrderFill(
      id: json['id'],
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
    );
  }
}

class MarketOrderPosition {
  final int id;
  final String tradeId;
  final String symbol;
  final String side;
  final double quantity;
  final double entryPrice;
  final double markPrice;
  final int leverage;
  final double margin;
  final double unrealizedPnl;
  final double realizedPnl;
  final String status;

  const MarketOrderPosition({
    required this.id,
    required this.tradeId,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.entryPrice,
    required this.markPrice,
    required this.leverage,
    required this.margin,
    required this.unrealizedPnl,
    required this.realizedPnl,
    required this.status,
  });

  factory MarketOrderPosition.fromJson(Map<String, dynamic> json) {
    return MarketOrderPosition(
      id: json['id'],
      tradeId: json['tradeId'],
      symbol: json['symbol'],
      side: json['side'],
      quantity: (json['quantity'] as num).toDouble(),
      entryPrice: (json['entryPrice'] as num).toDouble(),
      markPrice: (json['markPrice'] as num).toDouble(),
      leverage: (json['leverage'] as num).toInt(),
      margin: (json['margin'] as num).toDouble(),
      unrealizedPnl: (json['unrealizedPnl'] as num).toDouble(),
      realizedPnl: (json['realizedPnl'] as num).toDouble(),
      status: json['status'],
    );
  }
}

class MarketOrderAccount {
  final String accountId;
  final double balance;
  final double availableBalance;
  final double usedMargin;
  final double realizedPnl;
  final double totalFees;

  const MarketOrderAccount({
    required this.accountId,
    required this.balance,
    required this.availableBalance,
    required this.usedMargin,
    required this.realizedPnl,
    required this.totalFees,
  });

  factory MarketOrderAccount.fromJson(Map<String, dynamic> json) {
    return MarketOrderAccount(
      accountId: json['accountId'],
      balance: (json['balance'] as num).toDouble(),
      availableBalance: (json['availableBalance'] as num).toDouble(),
      usedMargin: (json['usedMargin'] as num).toDouble(),
      realizedPnl: (json['realizedPnl'] as num).toDouble(),
      totalFees: (json['totalFees'] as num).toDouble(),
    );
  }
}