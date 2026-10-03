class TradingAccountModel {
  final String accountId;
  final String currency;
  final double balance;
  final double availableBalance;
  final double usedMargin;
  final double realizedPnl;
  final double totalFees;
  final String status;

  const TradingAccountModel({
    required this.accountId,
    required this.currency,
    required this.balance,
    required this.availableBalance,
    required this.usedMargin,
    required this.realizedPnl,
    required this.totalFees,
    required this.status,
  });

  factory TradingAccountModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TradingAccountModel(
      accountId: json['accountId'] as String,
      currency: json['currency'] as String,
      balance: double.tryParse(
        json['balance'].toString(),
      ) ??
          0,
      availableBalance: double.tryParse(
        json['availableBalance'].toString(),
      ) ??
          0,
      usedMargin: double.tryParse(
        json['usedMargin'].toString(),
      ) ??
          0,
      realizedPnl: double.tryParse(
        json['realizedPnl'].toString(),
      ) ??
          0,
      totalFees: double.tryParse(
        json['totalFees'].toString(),
      ) ??
          0,
      status: json['status'] as String,
    );
  }
}