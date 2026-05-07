import '../../../domain/entities/binance/candle_entity.dart';

class CandleModel extends CandleEntity {
  CandleModel({
    required super.time,
    required super.open,
    required super.high,
    required super.low,
    required super.close,
    required super.volume,
  });

  factory CandleModel.fromJson(Map<String, dynamic> json) {
    return CandleModel(
      time: DateTime.fromMillisecondsSinceEpoch(json['time']),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
    );
  }
}
