import '../../../../../core/network/methods/post_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';

class PositionCloseRepository {
  final PostMethod _postMethod = PostMethod();

  Future<Map<String, dynamic>> closePosition({
    required String accountId,
    required String tradeId,
    required String symbol,
    required String side,
    required double quantity,
  }) async {
    final response = await _postMethod.postRequest(
      endpoint:
      '${ApiUrls.tradingPositions}/$tradeId/close',
      data: {
        'accountId': accountId,
        'symbol': symbol,
        'side': side,
        'quantity': quantity,
      },
    );

    return response.data as Map<String, dynamic>;
  }
}