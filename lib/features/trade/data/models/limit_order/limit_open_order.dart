
class LimitOpenOrder{
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
  final String status;
  final double filledQuantity;
  final double? averagePrice;
  final DateTime? createdAt;

  const LimitOpenOrder({
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
    required this.status,
    required this.filledQuantity,
    required this.averagePrice,
    required this.createdAt,
  });

  factory LimitOpenOrder.fromJson(Map<String, dynamic> json) {
    return LimitOpenOrder(
      id: (json['id'] as num).toInt(),
      tradeId: json['tradeId'] as String,
      accountId: json['accountId'] as String,
      symbol: json['symbol'] as String,
      side: json['side'] as String,
      positionSide: json['positionSide'] as String,
      orderType: json['orderType'] as String,
      quantity: double.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      leverage: (json['leverage'] as num).toInt(),
      marginMode: json['marginMode'] as String,
      status: json['status'] as String,
      filledQuantity:
      double.parse(json['filledQuantity'].toString()),
      averagePrice: json['averagePrice'] == null
          ? null
          : double.parse(json['averagePrice'].toString()),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
    );
  }
}
