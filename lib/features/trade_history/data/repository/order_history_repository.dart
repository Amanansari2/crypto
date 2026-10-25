import 'package:crypto_app/features/trade_history/data/model/order_history_model.dart';

import '../../../../../core/network/methods/get_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';

class OrderHistoryRepository {
  final GetMethod _getMethod = GetMethod();

  Future<OrderHistoryResponseModel> getOrderHistory({
    required String accountId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _getMethod.getRequest(
      endpoint: '${ApiUrls.orderHistory}/$accountId',
      queryParams: {
        'page': page,
        'limit': limit,
      },
    );

    return OrderHistoryResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map)
    );
  }
}