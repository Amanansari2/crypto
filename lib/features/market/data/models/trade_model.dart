class TradeModel {
  final double price;
  final double quantity;
  final bool isSell;
  final int time;

  const TradeModel({
    required this.price,
    required this.quantity,
    required this.isSell,
    required this.time,
  });

  factory TradeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TradeModel(
      price: (json["price"] as num).toDouble(),

      quantity: (json["quantity"] as num).toDouble(),

      isSell: json["isBuyerMaker"] ?? false,

      time: (json["transactionTime"] as num?)?.toInt() ?? 0,
    );
  }
}