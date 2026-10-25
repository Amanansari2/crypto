
import 'pagination_model.dart';

class PositionHistoryResponseModel {
  final bool success;
  final List<PositionHistoryModel> positions;
  final PaginationModel pagination;

  const PositionHistoryResponseModel({
    required this.success,
    required this.positions,
    required this.pagination,
  });

  factory PositionHistoryResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final positionsJson = json['positions'] as List? ?? [];

    return PositionHistoryResponseModel(
      success: json['success'] as bool? ?? false,
      positions: positionsJson
          .map(
            (item) => PositionHistoryModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
      pagination: PaginationModel.fromJson(
        Map<String, dynamic>.from(
          json['pagination'] as Map? ?? {},
        ),
      ),
    );
  }
}

class PositionHistoryModel {
  final String id;
  final String? tradeId;
  final String? accountId;
  final String symbol;
  final String side;
  final double quantity;
  final double entryPrice;
  final double markPrice;
  final int? leverage;
  final String? marginMode;
  final double margin;
  final double unrealizedPnl;
  final double realizedPnl;
  final double? liquidationPrice;
  final double? takeProfit;
  final double? stopLoss;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? exitPrice;
  final DateTime? closedAt;

  const PositionHistoryModel({
    required this.id,
    this.tradeId,
    this.accountId,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.entryPrice,
    required this.markPrice,
    this.leverage,
    this.marginMode,
    required this.margin,
    required this.unrealizedPnl,
    required this.realizedPnl,
    this.liquidationPrice,
    this.takeProfit,
    this.stopLoss,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.exitPrice,
    this.closedAt,
  });

  factory PositionHistoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    DateTime? toDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString());
    }

    return PositionHistoryModel(
      id: json['id']?.toString() ?? '',
      tradeId: json['tradeId']?.toString(),
      accountId: json['accountId']?.toString(),
      symbol: json['symbol']?.toString() ?? '',
      side: json['side']?.toString() ?? '',
      quantity: toDouble(json['quantity']) ?? 0,
      entryPrice: toDouble(json['entryPrice']) ?? 0,
      markPrice: toDouble(json['markPrice']) ?? 0,
      leverage: json['leverage'] == null
          ? null
          : int.tryParse(json['leverage'].toString()),
      marginMode: json['marginMode']?.toString(),
      margin: toDouble(json['margin']) ?? 0,
      unrealizedPnl: toDouble(json['unrealizedPnl']) ?? 0,
      realizedPnl: toDouble(json['realizedPnl']) ?? 0,
      liquidationPrice: toDouble(json['liquidationPrice']),
      takeProfit: toDouble(json['takeProfit']),
      stopLoss: toDouble(json['stopLoss']),
      status: json['status']?.toString() ?? '',
      createdAt: toDate(json['createdAt'] ?? json['created_at']),
      updatedAt: toDate(json['updatedAt'] ?? json['updated_at']),
      exitPrice: toDouble(json['exitPrice']),
      closedAt: toDate(json['closedAt']),
    );
  }
}
