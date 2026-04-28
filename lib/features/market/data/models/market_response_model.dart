import 'coin_model.dart';

class MarketResponseModel {
  final bool success;
  final String message;
  final List<CoinModel> coins;
  final int currentPage;
  final bool hasMore;

  MarketResponseModel({
    required this.success,
    required this.message,
    required this.coins,
    required this.currentPage,
    required this.hasMore,
  });

  factory MarketResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return MarketResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      coins: (data['coins'] as List? ?? [])
          .map((e) => CoinModel.fromJson(e))
          .toList(),
      currentPage: data['currentPage'] ?? 1,
      hasMore: data['hasMore'] ?? false,
    );
  }
}
