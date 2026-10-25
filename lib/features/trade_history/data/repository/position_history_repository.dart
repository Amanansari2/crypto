import 'package:crypto_app/features/trade_history/data/model/position_history_model.dart';

import '../../../../../core/network/methods/get_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';

class PositionHistoryRepository {
  final GetMethod _getMethod = GetMethod();

  Future<PositionHistoryResponseModel> getPositionHistory({
    required String accountId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _getMethod.getRequest(
      endpoint: '${ApiUrls.positionHistory}/$accountId',
      queryParams: {'page': page, 'limit': limit},
    );

    return PositionHistoryResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
