


import 'coin_model.dart';

class MarketResponseModel {
  final bool success;
  final String message;
  final List<CoinModel> coins;
  final int currentPage;
  final bool hasMore;

  const MarketResponseModel({
    required this.success,
    required this.message,
    required this.coins,
    required this.currentPage,
    required this.hasMore,
  });

  factory MarketResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return MarketResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      coins: (data['coins'] as List<dynamic>? ?? [])
          .map((e) => CoinModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: data['currentPage'] as int? ?? 1,
      hasMore: data['hasMore'] as bool? ?? false,
    );
  }

  MarketResponseModel copyWith({
    bool? success,
    String? message,
    List<CoinModel>? coins,
    int? currentPage,
    bool? hasMore,
  }) {
    return MarketResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      coins: coins ?? this.coins,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

}

