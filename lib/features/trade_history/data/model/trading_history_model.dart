import 'package:crypto_app/features/trade_history/data/model/pagination_model.dart';

class TradingHistoryResponseModel {
  final bool success;
  final List<TradingHistoryModel> trades;
  final PaginationModel pagination;

  const TradingHistoryResponseModel({
    required this.success,
    required this.trades,
    required this.pagination,
  });

  factory TradingHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TradingHistoryResponseModel(
      success: json['success'] as bool? ?? false,
      trades: (json['trades'] as List<dynamic>? ?? [])
          .map(
            (item) => TradingHistoryModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      pagination: PaginationModel.fromJson(
        Map<String, dynamic>.from(json['pagination'] as Map? ?? {}),
      ),
    );
  }
}

class TradingHistoryModel {
  final int? id;
  final int? orderId;
  final int? positionId;
  final String accountId;
  final String symbol;
  final String side;
  final double quantity;
  final double price;
  final double? fee;
  final double? realizedPnl;
  final DateTime? createdAt;

  const TradingHistoryModel({
    this.id,
    this.orderId,
    this.positionId,
    required this.accountId,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    this.fee,
    this.realizedPnl,
    this.createdAt,
  });

  factory TradingHistoryModel.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString());
    }

    return TradingHistoryModel(
      id: parseInt(json['id']),
      orderId: parseInt(json['orderId']),
      positionId: parseInt(json['positionId']),
      accountId: json['accountId']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      side: json['side']?.toString() ?? '',
      quantity: parseDouble(json['quantity']) ?? 0,
      price: parseDouble(json['price']) ?? 0,
      fee: parseDouble(json['fee']),
      realizedPnl: parseDouble(json['realizedPnl']),
      createdAt: parseDate(json['createdAt']),
    );
  }
}
