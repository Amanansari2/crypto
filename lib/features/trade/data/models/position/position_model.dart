class PositionModel {
  final int id;
  final String tradeId;
  final String accountId;
  final String symbol;
  final String side;
  final double quantity;
  final double entryPrice;
  final double markPrice;
  final double leverage;
  final String marginMode;
  final double margin;
  final double unrealizedPnl;
  final double realizedPnl;
  final double? liquidationPrice;
  final double? takeProfit;
  final double? stopLoss;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PositionModel({
    required this.id,
    required this.tradeId,
    required this.accountId,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.entryPrice,
    required this.markPrice,
    required this.leverage,
    required this.marginMode,
    required this.margin,
    required this.unrealizedPnl,
    required this.realizedPnl,
    this.liquidationPrice,
    this.takeProfit,
    this.stopLoss,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      id: json['id'] as int,
      tradeId: json['tradeId'] as String,
      accountId: json['accountId'] as String,
      symbol: json['symbol'] as String,
      side: json['side'] as String,
      quantity: double.parse(json['quantity'].toString()),
      entryPrice: double.parse(json['entryPrice'].toString()),
      markPrice: double.parse(json['markPrice'].toString()),
      leverage: double.parse(json['leverage'].toString()),
      marginMode: json['marginMode'] as String,
      margin: double.parse(json['margin'].toString()),
      unrealizedPnl: double.parse(
        json['unrealizedPnl'].toString(),
      ),
      realizedPnl: double.parse(
        json['realizedPnl'].toString(),
      ),
      liquidationPrice: json['liquidationPrice'] == null
          ? null
          : double.parse(
        json['liquidationPrice'].toString(),
      ),
      takeProfit: json['takeProfit'] == null
          ? null
          : double.parse(
        json['takeProfit'].toString(),
      ),
      stopLoss: json['stopLoss'] == null
          ? null
          : double.parse(
        json['stopLoss'].toString(),
      ),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: DateTime.parse(json['updatedAt'].toString()),
    );
  }
}