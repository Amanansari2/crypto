import '../../domain/entities/coin_entity.dart';

class CoinModel {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double price;
  final double change24h;
  final String marketCap;
  final String volume;
  final int rank;
  final List<double> sparklines;

  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
    required this.change24h,
    required this.marketCap,
    required this.volume,
    required this.rank,
    required this.sparklines,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val.toDouble();
      if (val is double) return val;
      return double.tryParse(val.toString()) ?? 0;
    }

    return CoinModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      image: json['image'] ?? '',
      price: parseDouble(json['currentPrice']),
      change24h: parseDouble(json['priceChangePercentage24h']),
      marketCap: json['marketCap']?.toString() ?? '0',
      volume: json['volume']?.toString() ?? '0',
      rank: json['marketCapRank'] ?? '0',
      sparklines:
          (json['sparkline'] as List?)?.map((e) => parseDouble(e)).toList() ??
          [],
    );
  }
}

extension CoinMapper on CoinModel {
  CoinEntity toEntity() {
    return CoinEntity(
      id: id,
      name: name,
      symbol: symbol,
      image: image,
      price: price,
      change24h: change24h,
      marketCap: marketCap,
      volume: volume,
      rank: rank,
      sparklines: sparklines,
    );
  }
}
