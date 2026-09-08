class BinanceTickerModel {
  final String symbol;

  // Price
  final double lastPrice;
  final double priceChange;
  final double priceChangePercent;

  // 24H statistics
  final double open;
  final double high;
  final double low;
  final double weightedAveragePrice;
  final double volume;
  final double quoteVolume;
  final double tradeCount;

  // Market data
  final double bid;
  final double ask;
  final double bidQuantity;
  final double askQuantity;

  // Futures
  final double markPrice;

  BinanceTickerModel({
    required this.symbol,
    required this.lastPrice,
    required this.priceChange,
    required this.priceChangePercent,
    required this.open,
    required this.high,
    required this.low,
    required this.weightedAveragePrice,
    required this.volume,
    required this.quoteVolume,
    required this.tradeCount,
    required this.bid,
    required this.ask,
    required this.bidQuantity,
    required this.askQuantity,
    required this.markPrice,
  });

  factory BinanceTickerModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    return BinanceTickerModel(
      symbol: json['symbol'] ?? '',
      lastPrice: parse(json['lastPrice']),
      priceChange: parse(json['priceChange']),
      priceChangePercent: parse(json['priceChangePercent']),
      open: parse(json['openPrice']),
      high: parse(json['highPrice']),
      low: parse(json['lowPrice']),
      weightedAveragePrice: parse(json['weightedAveragePrice']),
      volume: parse(json['volume']),
      quoteVolume: parse(json['quoteVolume']),
      tradeCount: parse(json['tradeCount']),
      bid: parse(json['bidPrice']),
      ask: parse(json['askPrice']),
      bidQuantity: parse(json['bidQuantity']),
      askQuantity: parse(json['askQuantity']),
      markPrice: parse(json['markPrice']),
    );
  }
}