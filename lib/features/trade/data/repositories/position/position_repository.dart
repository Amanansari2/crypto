import '../../../../../core/network/methods/get_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';
import '../../models/position/position_model.dart';

class PositionRepository {
  final GetMethod _getMethod = GetMethod();

  Future<List<PositionModel>> getOpenPositions(
      String accountId,
      ) async {
    final response = await _getMethod.getRequest(
      endpoint: '${ApiUrls.tradingPositions}/$accountId',
    );

    final positions = response.data['positions'] as List;

    return positions
        .map(
          (json) => PositionModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}