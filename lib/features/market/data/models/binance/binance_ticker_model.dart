import 'package:crypto_app/features/market/domain/entities/binance/ticker_entity.dart';

class BinanceTickerModel extends BinanceTickerEntity {
  BinanceTickerModel({
    required super.symbol,
    required super.lastPrice,
    required super.priceChangePercent,
    required super.priceChange,
    required super.high,
    required super.low,
    required super.open,
    required super.volume,
    required super.quoteVolume,
    required super.bid,
    required super.ask,
  });

  factory BinanceTickerModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    return BinanceTickerModel(
      symbol: json['s'] ?? '',
      lastPrice: parse(json['c']),
      priceChangePercent: parse(json['P']),
      priceChange: parse(json['p']),
      high: parse(json['h']),
      low: parse(json['l']),
      open: parse(json['o']),
      volume: parse(json['v']),
      quoteVolume: parse(json['q']),
      bid: parse(json['b']),
      ask: parse(json['a']),
    );
  }
}
