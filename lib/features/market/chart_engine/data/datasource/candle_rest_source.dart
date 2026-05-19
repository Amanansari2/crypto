import 'package:crypto_app/core/network/methods/get_method.dart';
import 'package:crypto_app/features/market/chart_engine/core/models/candle_model.dart';

import '../../../../../core/utils/constants/api_urls.dart';

class CandleRestSource {
  final GetMethod _get;

  CandleRestSource({GetMethod? getMethod}) : _get = getMethod ?? GetMethod();

  Future<(List<CandleModel>, int?)> getCandles({
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
      return (<CandleModel>[], null);
    }

    final candles = response
        .map((e) => CandleModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final nextEndTime = res.data['meta']?['nextEndTime'] as int?;

    return (candles, nextEndTime);
  }
}
