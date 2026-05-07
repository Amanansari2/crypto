import 'package:crypto_app/core/utils/constants/api_urls.dart';
import 'package:crypto_app/features/market/data/models/binance/candle_model.dart';
import 'package:crypto_app/features/market/domain/entities/binance/candle_entity.dart';

import '../../../../../../core/network/methods/get_method.dart';

class CandleRemoteDatasource {
  final GetMethod _get;

  CandleRemoteDatasource({GetMethod? getMethod})
    : _get = getMethod ?? GetMethod();

  Future<(List<CandleEntity>, int?)> getCandles({
    required String symbol,
    required String interval,
    int limit = 100,
    int? endTime,
  }) async {
    final res = await _get.getRequest(
      endpoint: ApiUrls.getCandles,
      queryParams: {
        "symbol": symbol.toUpperCase(),
        "interval": interval,
        "limit": limit,
        if (endTime != null) "endTime": endTime,
      },
    );
    if (res.data == null) {
      throw Exception("Empty response from server");
    }

    if (res.data['success'] != true) {
      throw Exception(res.data['error'] ?? "Failed to fetch candles");
    }

    final List response = (res.data['data'] ?? []) as List;
    if (response.isEmpty) {
      return (<CandleEntity>[], null);
    }

    final candles = response
        .map((e) => CandleModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final nextEndTime = res.data['meta']?['nextEndTime'] as int?;

    return (candles, nextEndTime);
  }
}
