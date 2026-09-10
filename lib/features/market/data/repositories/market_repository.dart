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

  Future<MarketResponseModel> getAllCoins({int page = 1, String search = ""}) =>
      _fetch(ApiUrls.allCoins, query: {
        'page': page,
      if(search.isNotEmpty) 'search' : search
      });

  Future<MarketResponseModel> getTrendingCoins() => _fetch(ApiUrls.trending);

  Future<MarketResponseModel> getGainersCoins() => _fetch(ApiUrls.gainers);

  Future<MarketResponseModel> getLosersCoins() => _fetch(ApiUrls.losers);

  Future<MarketResponseModel> getNewCoins() => _fetch(ApiUrls.newCoins);
}
