
class WalletTradeHistoryResponseModel {
  final bool success;
  final List<WalletTradeModel> trades;
  final WalletTradePaginationModel pagination;

  const WalletTradeHistoryResponseModel({
    required this.success,
    required this.trades,
    required this.pagination,
  });

  factory WalletTradeHistoryResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WalletTradeHistoryResponseModel(
      success: json['success'] as bool? ?? false,
      trades: (json['trades'] as List? ?? [])
          .map(
            (item) => WalletTradeModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
      pagination: WalletTradePaginationModel.fromJson(
        Map<String, dynamic>.from(
          json['pagination'] as Map? ?? {},
        ),
      ),
    );
  }
}

class WalletTradeModel {
  final String tradeId;
  final String symbol;
  final String status;
  final DateTime? firstOrderAt;
  final DateTime? lastOrderAt;
  final List<WalletTradeOrderModel> orders;
  final List<WalletTradeFillModel> fills;
  final WalletTradeSummaryModel summary;

  const WalletTradeModel({
    required this.tradeId,
    required this.symbol,
    required this.status,
    required this.firstOrderAt,
    required this.lastOrderAt,
    required this.orders,
    required this.fills,
    required this.summary,
  });

  factory WalletTradeModel.fromJson(Map<String, dynamic> json) {
    return WalletTradeModel(
      tradeId: json['tradeId']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      firstOrderAt: DateTime.tryParse(
        json['firstOrderAt']?.toString() ?? '',
      ),
      lastOrderAt: DateTime.tryParse(
        json['lastOrderAt']?.toString() ?? '',
      ),
      orders: (json['orders'] as List? ?? [])
          .map(
            (item) => WalletTradeOrderModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
      fills: (json['fills'] as List? ?? [])
          .map(
            (item) => WalletTradeFillModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
      summary: WalletTradeSummaryModel.fromJson(
        Map<String, dynamic>.from(
          json['summary'] as Map? ?? {},
        ),
      ),
    );
  }
}

class WalletTradeOrderModel {
  final int id;
  final String tradeId;
  final String symbol;
  final String side;
  final String positionSide;
  final String orderType;
  final double quantity;
  final double filledQuantity;
  final double price;
  final double? averagePrice;
  final int leverage;
  final String marginMode;
  final String status;
  final double fee;
  final DateTime? createdAt;

  const WalletTradeOrderModel({
    required this.id,
    required this.tradeId,
    required this.symbol,
    required this.side,
    required this.positionSide,
    required this.orderType,
    required this.quantity,
    required this.filledQuantity,
    required this.price,
    required this.averagePrice,
    required this.leverage,
    required this.marginMode,
    required this.status,
    required this.fee,
    required this.createdAt,
  });

  factory WalletTradeOrderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WalletTradeOrderModel(
      id: _toInt(json['id']),
      tradeId: json['tradeId']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      side: json['side']?.toString() ?? '',
      positionSide: json['positionSide']?.toString() ?? '',
      orderType: json['orderType']?.toString() ?? '',
      quantity: _toDouble(json['quantity']),
      filledQuantity: _toDouble(json['filledQuantity']),
      price: _toDouble(json['price']),
      averagePrice: json['averagePrice'] == null
          ? null
          : _toDouble(json['averagePrice']),
      leverage: _toInt(json['leverage']),
      marginMode: json['marginMode']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      fee: _toDouble(json['fee']),
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

class WalletTradeFillModel {
  final int id;
  final int orderId;
  final int positionId;
  final String symbol;
  final String side;
  final double quantity;
  final double price;
  final double fee;
  final double realizedPnl;
  final DateTime? createdAt;

  const WalletTradeFillModel({
    required this.id,
    required this.orderId,
    required this.positionId,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.fee,
    required this.realizedPnl,
    required this.createdAt,
  });

  factory WalletTradeFillModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WalletTradeFillModel(
      id: _toInt(json['id']),
      orderId: _toInt(json['orderId']),
      positionId: _toInt(json['positionId']),
      symbol: json['symbol']?.toString() ?? '',
      side: json['side']?.toString() ?? '',
      quantity: _toDouble(json['quantity']),
      price: _toDouble(json['price']),
      fee: _toDouble(json['fee']),
      realizedPnl: _toDouble(json['realizedPnl']),
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

class WalletTradeSummaryModel {
  final int fillCount;
  final double filledQuantity;
  final double? averageFillPrice;
  final double totalFees;
  final double realizedPnl;
  final double netRealizedPnl;

  const WalletTradeSummaryModel({
    required this.fillCount,
    required this.filledQuantity,
    required this.averageFillPrice,
    required this.totalFees,
    required this.realizedPnl,
    required this.netRealizedPnl,
  });

  factory WalletTradeSummaryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WalletTradeSummaryModel(
      fillCount: _toInt(json['fillCount']),
      filledQuantity: _toDouble(json['filledQuantity']),
      averageFillPrice: json['averageFillPrice'] == null
          ? null
          : _toDouble(json['averageFillPrice']),
      totalFees: _toDouble(json['totalFees']),
      realizedPnl: _toDouble(json['realizedPnl']),
      netRealizedPnl: _toDouble(json['netRealizedPnl']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

class WalletTradePaginationModel {
  final int limit;
  final int offset;
  final int total;
  final bool hasMore;
  final int nextOffset;

  const WalletTradePaginationModel({
    required this.limit,
    required this.offset,
    required this.total,
    required this.hasMore,
    required this.nextOffset,
  });

  factory WalletTradePaginationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WalletTradePaginationModel(
      limit: _toInt(json['limit']),
      offset: _toInt(json['offset']),
      total: _toInt(json['total']),
      hasMore: json['hasMore'] as bool? ?? false,
      nextOffset: _toInt(json['nextOffset']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
