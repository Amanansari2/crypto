class ContractInfoModel {
  final String symbol;

  final String settlementCrypto;

  final String tickSize;

  final String leverage;

  final String fundingFeeSettled;

  final String? fundingRate;

  final int? nextFundingTime;

  final String maxLimitOrderSize;

  final String maxMarketOrderSize;

  final String baseAsset;

  final String quoteAsset;

  final String contractType;

  const ContractInfoModel({
    required this.symbol,
    required this.settlementCrypto,
    required this.tickSize,
    required this.leverage,
    required this.fundingFeeSettled,
    required this.maxLimitOrderSize,
    required this.maxMarketOrderSize,
    required this.baseAsset,
    required this.quoteAsset,
    required this.contractType,
    this.fundingRate,
    this.nextFundingTime,
  });

  factory ContractInfoModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ContractInfoModel(
      symbol: json["symbol"] ?? "",

      settlementCrypto:
      json["settlementCrypto"] ?? "",

      tickSize:
      json["tickSize"]?.toString() ?? "",

      leverage:
      json["leverage"] ?? "",

      fundingFeeSettled:
      json["fundingFeeSettled"] ?? "",

      fundingRate:
      json["fundingRate"]?.toString(),

      nextFundingTime:
      json["nextFundingTime"],

      maxLimitOrderSize:
      json["maxLimitOrderSize"]?.toString() ?? "",

      maxMarketOrderSize:
      json["maxMarketOrderSize"]?.toString() ?? "",

      baseAsset:
      json["baseAsset"] ?? "",

      quoteAsset:
      json["quoteAsset"] ?? "",

      contractType:
      json["contractType"] ?? "",
    );
  }
}