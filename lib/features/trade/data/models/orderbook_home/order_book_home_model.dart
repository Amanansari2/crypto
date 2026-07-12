class OrderBookHomeModel {
  final int lastUpdateId;
  final List<OrderBookEntry> bids;
  final List<OrderBookEntry> asks;

  const OrderBookHomeModel({
    required this.lastUpdateId,
    required this.bids,
    required this.asks,
  });

  factory OrderBookHomeModel.fromJson(Map<String, dynamic> json) {
    return OrderBookHomeModel(
      lastUpdateId: json['lastUpdateId'] ?? 0,
      bids: (json['bids'] as List)
          .map(
            (e) => OrderBookEntry(
          price: double.parse(e[0].toString()),
          quantity: double.parse(e[1].toString()),
        ),
      )
          .toList(),
      asks: (json['asks'] as List)
          .map(
            (e) => OrderBookEntry(
          price: double.parse(e[0].toString()),
          quantity: double.parse(e[1].toString()),
        ),
      )
          .toList(),
    );
  }
}

class OrderBookEntry {
  final double price;
  final double quantity;

  const OrderBookEntry({
    required this.price,
    required this.quantity,
  });
}