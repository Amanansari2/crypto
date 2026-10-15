
import '../../../../../core/network/methods/get_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';
import '../models/limit_order/limit_open_order.dart';

class LimitOpenOrderRepository {
  final GetMethod _getMethod = GetMethod();

  Future<List<LimitOpenOrder>> getOpenLimitOrders(
      String accountId,
      ) async {
    final response = await _getMethod.getRequest(
      endpoint: '${ApiUrls.openLimitOrders}/$accountId',
    );

    final orders = response.data['orders'] as List;

    return orders
        .map(
          (json) => LimitOpenOrder.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}
