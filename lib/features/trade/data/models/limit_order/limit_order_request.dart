class LimitOrderRequest {
  final String accountId;
  final String symbol;
  final String side;
  final double quantity;
  final double price;
  final int leverage;
  final String marginMode;
  final double? takeProfit;
  final double? stopLoss;

  const LimitOrderRequest({
    required this.accountId,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.leverage,
    required this.marginMode,
    this.takeProfit,
    this.stopLoss,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'symbol': symbol,
      'side': side,
      'quantity': quantity,
      'price': price,
      'leverage': leverage,
      'marginMode': marginMode,
      'takeProfit': takeProfit,
      'stopLoss': stopLoss,
    };
  }
}