
import '../../../../../core/network/methods/get_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';
import '../../../../core/network/methods/delete_method.dart';
import '../../../../core/network/methods/put_method.dart';
import '../models/limit_order/limit_open_order.dart';

class LimitOpenOrderRepository {
  final GetMethod _getMethod = GetMethod();
  final PutMethod _putMethod = PutMethod();
  final DeleteMethod _deleteMethod = DeleteMethod();


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

  Future<Map<String, dynamic>> modifyLimitOrder({
    required String tradeId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _putMethod.putRequest(
      endpoint: '${ApiUrls.modifyLimitOrders}/$tradeId/modify',
      data: data,
    );

    return Map<String, dynamic>.from(response.data as Map);
  }


  Future<Map<String, dynamic>> cancelLimitOrder({
    required String tradeId,
    required String accountId,
  }) async {
    final response = await _deleteMethod.deleteRequest(
      endpoint: '${ApiUrls.modifyLimitOrders}/$tradeId',
      data: {
        'accountId': accountId,
      },
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

}
