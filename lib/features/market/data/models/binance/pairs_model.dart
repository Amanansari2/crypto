import 'package:crypto_app/features/market/domain/entities/binance/pair_entity.dart';

class BinanceResponseModel {
  final bool success;
  final int count;
  final List<PairModel> pairs;

  BinanceResponseModel({
    required this.success,
    required this.count,
    required this.pairs,
  });

  factory BinanceResponseModel.fromJson(Map<String, dynamic> json) {
    final List list = (json['data'] ?? []) as List;
    return BinanceResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      pairs: list.map((e) => PairModel.fromJson(e)).toList(),
    );
  }
}

class PairModel extends PairEntity {
  PairModel({required super.symbol, required super.baseAsset});

  factory PairModel.fromJson(Map<String, dynamic> json) {
    return PairModel(
      symbol: json['symbol'] ?? '',
      baseAsset: json['baseAsset'] ?? '',
    );
  }
}
