



class CoinModel {
  final int id;
  final String symbol;
  final String name;
  final String image;

  final double currentPrice;
  final double priceChangePercentage24h;
  final double highPrice;
  final double lowPrice;

  final String quoteVolume;
  final double quoteVolumeRaw;

  final double openPrice;
  final double weightedAvgPrice;

  const CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.highPrice,
    required this.lowPrice,
    required this.quoteVolume,
    required this.quoteVolumeRaw,
    required this.openPrice,
    required this.weightedAvgPrice,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] ?? 0,
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      priceChangePercentage24h:
      (json['priceChangePercentage24h'] ?? 0).toDouble(),
      highPrice: (json['highPrice'] ?? 0).toDouble(),
      lowPrice: (json['lowPrice'] ?? 0).toDouble(),
      quoteVolume: json['quoteVolume'] ?? '',
      quoteVolumeRaw: (json['quoteVolumeRaw'] ?? 0).toDouble(),
      openPrice: (json['openPrice'] ?? 0).toDouble(),
      weightedAvgPrice: (json['weightedAvgPrice'] ?? 0).toDouble(),
    );
  }
}