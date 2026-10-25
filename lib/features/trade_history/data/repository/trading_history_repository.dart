import 'package:crypto_app/features/trade_history/data/model/trading_history_model.dart';

import '../../../../../core/network/methods/get_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';

class TradingHistoryRepository {
  final GetMethod _getMethod = GetMethod();

  Future<TradingHistoryResponseModel> getTradingHistory({
    required String accountId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _getMethod.getRequest(
      endpoint: '${ApiUrls.tradingHistory}/$accountId',
      queryParams: {'page': page, 'limit': limit},
    );

    return TradingHistoryResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
