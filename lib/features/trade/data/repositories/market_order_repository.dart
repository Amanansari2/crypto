import '../../../../core/network/methods/post_method.dart';
import '../../../../core/utils/constants/api_urls.dart';
import '../models/market_execuation/market_order_request.dart';
import '../models/market_execuation/market_order_response.dart';

class MarketOrderRepository {
  final PostMethod _postMethod = PostMethod();

  Future<MarketOrderResponse> placeMarketOrder(
      MarketOrderRequest request,
      ) async {
    final response = await _postMethod.postRequest(
      endpoint: ApiUrls.marketOrder,
      data: request.toJson(),
    );

    return MarketOrderResponse.fromJson(response.data);
  }
}