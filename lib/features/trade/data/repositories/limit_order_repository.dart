import '../../../../core/network/methods/post_method.dart';
import '../../../../core/utils/constants/api_urls.dart';
import '../models/limit_order/limit_order_request.dart';
import '../models/limit_order/limit_order_response.dart';

class LimitOrderRepository {
  final PostMethod _postMethod = PostMethod();

  Future<LimitOrderResponse> placeLimitOrder(
      LimitOrderRequest request,
      ) async {
    final response = await _postMethod.postRequest(
      endpoint: ApiUrls.limitOrder,
      data: request.toJson(),
    );

    return LimitOrderResponse.fromJson(response.data);
  }
}