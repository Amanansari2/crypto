
class WalletTransactionsResponseModel {
  final bool success;
  final List<WalletTransactionItemModel> transactions;
  final WalletTransactionsPaginationModel pagination;

  const WalletTransactionsResponseModel({
    required this.success,
    required this.transactions,
    required this.pagination,
  });

  factory WalletTransactionsResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WalletTransactionsResponseModel(
      success: json['success'] as bool? ?? false,
      transactions: (json['transactions'] as List? ?? [])
          .map(
            (item) => WalletTransactionItemModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
      pagination: WalletTransactionsPaginationModel.fromJson(
        Map<String, dynamic>.from(
          json['pagination'] as Map? ?? {},
        ),
      ),
    );
  }
}

class WalletTransactionItemModel {
  final int id;
  final String accountId;
  final String type;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String referenceType;
  final int? referenceId;
  final String description;
  final DateTime? createdAt;

  const WalletTransactionItemModel({
    required this.id,
    required this.accountId,
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.referenceType,
    required this.referenceId,
    required this.description,
    required this.createdAt,
  });

  factory WalletTransactionItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WalletTransactionItemModel(
      id: _toInt(json['id']),
      accountId: json['accountId']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: _toDouble(json['amount']),
      balanceBefore: _toDouble(json['balanceBefore']),
      balanceAfter: _toDouble(json['balanceAfter']),
      referenceType: json['referenceType']?.toString() ?? '',
      referenceId: json['referenceId'] == null
          ? null
          : _toInt(json['referenceId']),
      description: json['description']?.toString() ?? '',
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

class WalletTransactionsPaginationModel {
  final int limit;
  final int offset;
  final int total;
  final bool hasMore;
  final int nextOffset;

  const WalletTransactionsPaginationModel({
    required this.limit,
    required this.offset,
    required this.total,
    required this.hasMore,
    required this.nextOffset,
  });

  factory WalletTransactionsPaginationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WalletTransactionsPaginationModel(
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
