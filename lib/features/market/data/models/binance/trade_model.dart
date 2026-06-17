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
      price: double.parse(
        json["p"],
      ),
      quantity: double.parse(
        json["q"],
      ),
      isSell: json["m"] ?? false,
      time: json["T"] ?? 0,
    );
  }
}