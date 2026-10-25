
class WalletOverviewModel {
  final String accountId;
  final String currency;
  final double balance;
  final double availableBalance;
  final double usedMargin;
  final double realizedPnl;
  final double totalFees;
  final String status;
  final double unrealizedPnl;
  final List<WalletTransactionModel> recentTransactions;

  const WalletOverviewModel({
    required this.accountId,
    required this.currency,
    required this.balance,
    required this.availableBalance,
    required this.usedMargin,
    required this.realizedPnl,
    required this.totalFees,
    required this.status,
    required this.unrealizedPnl,
    required this.recentTransactions,
  });

  factory WalletOverviewModel.fromJson(Map<String, dynamic> json) {
    final wallet = json['wallet'] as Map<String, dynamic>;
    final transactions = json['recentTransactions'] as List? ?? [];

    return WalletOverviewModel(
      accountId: wallet['accountId']?.toString() ?? '',
      currency: wallet['currency']?.toString() ?? 'USDT',
      balance: _toDouble(wallet['balance']),
      availableBalance: _toDouble(wallet['availableBalance']),
      usedMargin: _toDouble(wallet['usedMargin']),
      realizedPnl: _toDouble(wallet['realizedPnl']),
      totalFees: _toDouble(wallet['totalFees']),
      status: wallet['status']?.toString() ?? '',
      unrealizedPnl: _toDouble(wallet['unrealizedPnl']),
      recentTransactions: transactions
          .map(
            (item) => WalletTransactionModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class WalletTransactionModel {
  final int id;
  final String type;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String referenceType;
  final String? referenceId;
  final String description;
  final DateTime? createdAt;

  const WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.referenceType,
    required this.referenceId,
    required this.description,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      type: json['type']?.toString() ?? '',
      amount: _toDouble(json['amount']),
      balanceBefore: _toDouble(json['balanceBefore']),
      balanceAfter: _toDouble(json['balanceAfter']),
      referenceType: json['referenceType']?.toString() ?? '',
      referenceId: json['referenceId']?.toString(),
      description: json['description']?.toString() ?? '',
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
