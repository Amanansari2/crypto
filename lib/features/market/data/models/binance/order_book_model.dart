class OrderBookModel {
  final int lastUpdateId;
  final List<OrderBookEntry> bids;
  final List<OrderBookEntry> asks;

  const OrderBookModel({
    required this.lastUpdateId,
    required this.bids,
    required this.asks,
  });

  factory OrderBookModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderBookModel(
      lastUpdateId: json['lastUpdateId'] ?? 0,

      bids: (json['bids'] as List)
          .map(
            (e) => OrderBookEntry(
          price: double.parse(e[0]),
          quantity: double.parse(e[1]),
        ),
      )
          .toList(),

      asks: (json['asks'] as List)
          .map(
            (e) => OrderBookEntry(
          price: double.parse(e[0]),
          quantity: double.parse(e[1]),
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