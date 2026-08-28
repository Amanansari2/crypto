import '../../../../core/network/methods/get_method.dart';
import '../../../../core/utils/constants/api_urls.dart';
import '../models/market_response_model.dart';

class MarketRepository {
  final GetMethod _get = GetMethod();

  Future<MarketResponseModel> _fetch(
      String endpoint, {
        Map<String, dynamic>? query,
      }) async {
    final response = await _get.getRequest(
      endpoint: endpoint,
      queryParams: query,
    );

    return MarketResponseModel.fromJson(response.data);
  }

  Future<MarketResponseModel> getAllCoins({int page = 1}) =>
      _fetch(ApiUrls.allCoins, query: {'page': page});

  Future<MarketResponseModel> getTrendingCoins() =>
      _fetch(ApiUrls.trending);

  Future<MarketResponseModel> getGainersCoins() =>
      _fetch(ApiUrls.gainers);

  Future<MarketResponseModel> getLosersCoins() =>
      _fetch(ApiUrls.losers);

  Future<MarketResponseModel> getNewCoins() =>
      _fetch(ApiUrls.newCoins);
}