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
      lastUpdateId:
      (json['updateId'] ?? json['lastUpdateId'] ?? 0) as int,

      bids: (json['bids'] as List)
          .map(
            (e) => OrderBookEntry(
          price: (e[0] as num).toDouble(),
          quantity: (e[1] as num).toDouble(),
        ),
      )
          .toList(),

      asks: (json['asks'] as List)
          .map(
            (e) => OrderBookEntry(
          price: (e[0] as num).toDouble(),
          quantity: (e[1] as num).toDouble(),
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