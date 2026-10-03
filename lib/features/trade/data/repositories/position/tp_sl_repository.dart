import '../../../../../core/network/methods/put_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';

class TpSlRepository {
  final PutMethod _putMethod = PutMethod();

  Future<Map<String, dynamic>> updateTpSl({
    required String accountId,
    required String tradeId,
    double? takeProfit,
    double? stopLoss,
  }) async {
    final response = await _putMethod.putRequest(
      endpoint:
      '${ApiUrls.tradingPositions}/$tradeId/tp-sl',
      data: {
        'accountId': accountId,
        'takeProfit': takeProfit,
        'stopLoss': stopLoss,
      },
    );

    return response.data as Map<String, dynamic>;
  }
}