class PositionPnlModel {
  final int id;
  final String tradeId;
  final String accountId;
  final String symbol;
  final String side;
  final double quantity;
  final double entryPrice;
  final double markPrice;
  final double margin;
  final double leverage;
  final double unrealizedPnl;
  final double roi;
  final String status;
  final DateTime timestamp;

  const PositionPnlModel({
    required this.id,
    required this.tradeId,
    required this.accountId,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.entryPrice,
    required this.markPrice,
    required this.margin,
    required this.leverage,
    required this.unrealizedPnl,
    required this.roi,
    required this.status,
    required this.timestamp,
  });

  factory PositionPnlModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PositionPnlModel(
      id: int.parse(
        json['id'].toString(),
      ),
      tradeId: json['tradeId'].toString(),
      accountId: json['accountId'].toString(),
      symbol: json['symbol'].toString(),
      side: json['side'].toString(),
      quantity: double.parse(
        json['quantity'].toString(),
      ),
      entryPrice: double.parse(
        json['entryPrice'].toString(),
      ),
      markPrice: double.parse(
        json['markPrice'].toString(),
      ),
      margin: double.parse(
        json['margin'].toString(),
      ),
      leverage: double.parse(
        json['leverage'].toString(),
      ),
      unrealizedPnl: double.parse(
        json['unrealizedPnl'].toString(),
      ),
      roi: double.parse(
        json['roi'].toString(),
      ),
      status: json['status'].toString(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        int.parse(
          json['timestamp'].toString(),
        ),
      ),
    );
  }
}