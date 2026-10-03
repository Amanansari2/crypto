class MarketOrderRequest {
  final String accountId;
  final String symbol;
  final String side;
  final double quantity;
  final int leverage;
  final String marginMode;
  final bool reduceOnly;
  final String? tradeId;
  final double? takeProfit;
  final double? stopLoss;

  const MarketOrderRequest({
    required this.accountId,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.leverage,
    required this.marginMode,
    required this.reduceOnly,
    this.tradeId,
    this.takeProfit,
    this.stopLoss,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'symbol': symbol,
      'side': side,
      'quantity': quantity,
      'leverage': leverage,
      'marginMode': marginMode,
      'reduceOnly': reduceOnly,
      'tradeId': tradeId,
      'takeProfit': takeProfit,
      'stopLoss': stopLoss,
    };
  }
}