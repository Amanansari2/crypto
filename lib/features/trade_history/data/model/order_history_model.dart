import 'pagination_model.dart';

class OrderHistoryResponseModel {
  final bool success;
  final List<OrderHistoryModel> orders;
  final PaginationModel pagination;

  const OrderHistoryResponseModel({
    required this.success,
    required this.orders,
    required this.pagination,
  });

  factory OrderHistoryResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final ordersJson = json['orders'] as List? ?? [];

    return OrderHistoryResponseModel(
      success: json['success'] as bool? ?? false,
      orders: ordersJson
          .map(
            (item) => OrderHistoryModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
      pagination: PaginationModel.fromJson(
        Map<String, dynamic>.from(
          json['pagination'] as Map
        )
      ),
    );
  }
}


class OrderHistoryModel {
  final String id;
  final String? tradeId;
  final String? accountId;
  final String symbol;
  final String side;
  final String? positionSide;
  final String orderType;
  final double quantity;
  final double? price;
  final double? triggerPrice;
  final int? leverage;
  final String? marginMode;
  final bool? reduceOnly;
  final double? takeProfit;
  final double? stopLoss;
  final String status;
  final double filledQuantity;
  final double? averagePrice;
  final double fee;
  final String? parentOrderId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderHistoryModel({
    required this.id,
    this.tradeId,
    this.accountId,
    required this.symbol,
    required this.side,
    this.positionSide,
    required this.orderType,
    required this.quantity,
    this.price,
    this.triggerPrice,
    this.leverage,
    this.marginMode,
    this.reduceOnly,
    this.takeProfit,
    this.stopLoss,
    required this.status,
    required this.filledQuantity,
    this.averagePrice,
    required this.fee,
    this.parentOrderId,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    DateTime? toDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString());
    }

    return OrderHistoryModel(
      id: json['id']?.toString() ?? '',
      tradeId: json['tradeId']?.toString(),
      accountId: json['accountId']?.toString(),
      symbol: json['symbol']?.toString() ?? '',
      side: json['side']?.toString() ?? '',
      positionSide: json['positionSide']?.toString(),
      orderType: json['orderType']?.toString() ?? '',
      quantity: toDouble(json['quantity']) ?? 0,
      price: toDouble(json['price']),
      triggerPrice: toDouble(json['triggerPrice']),
      leverage: json['leverage'] == null
          ? null
          : int.tryParse(json['leverage'].toString()),
      marginMode: json['marginMode']?.toString(),
      reduceOnly: json['reduceOnly'] is bool
          ? json['reduceOnly'] as bool
          : null,
      takeProfit: toDouble(json['takeProfit']),
      stopLoss: toDouble(json['stopLoss']),
      status: json['status']?.toString() ?? '',
      filledQuantity: toDouble(json['filledQuantity']) ?? 0,
      averagePrice: toDouble(json['averagePrice']),
      fee: toDouble(json['fee']) ?? 0,
      parentOrderId: json['parentOrderId']?.toString(),
      createdAt: toDate(json['createdAt'] ?? json['created_at']),
      updatedAt: toDate(json['updatedAt'] ?? json['updated_at']),
    );
  }
}