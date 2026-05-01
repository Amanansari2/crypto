class BinanceTickerEntity {
  final String symbol;
  final double lastPrice;
  final double priceChangePercent;
  final double priceChange;
  final double high;
  final double low;
  final double open;
  final double volume;
  final double quoteVolume;
  final double bid;
  final double ask;

  BinanceTickerEntity({
    required this.symbol,
    required this.lastPrice,
    required this.priceChangePercent,
    required this.priceChange,
    required this.high,
    required this.low,
    required this.open,
    required this.volume,
    required this.quoteVolume,
    required this.bid,
    required this.ask,
  });
}
