import 'dart:collection';

import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:crypto_app/features/market/data/models/market_response_model.dart';

import '../../../../core/network/methods/get_method.dart';
import '../../../../core/utils/constants/api_urls.dart';

class MarketRemoteDataSource {
  final GetMethod _get;

  MarketRemoteDataSource({GetMethod? getMethod})
    : _get = getMethod ?? GetMethod();

  // final Map<String, (MarketResponseModel, DateTime)> _cache = {};

  final _cache = LinkedHashMap<String, (MarketResponseModel, DateTime)>();

  static const int _maxCacheSize = 50;

  void _enforceCacheLimit() {
    if (_cache.length > _maxCacheSize) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);

      LogHelper.log("🗑️ REMOVED OLDEST CACHE → $oldestKey");
    }
  }

  final Map<String, Future<MarketResponseModel>> _ongoingRequests = {};

  int _getCacheTTL(String endpoint) {
    if (endpoint == ApiUrls.trending) return 30;
    if (endpoint == ApiUrls.allCoins) return 10;
    if (endpoint == ApiUrls.gainers) return 15;
    if (endpoint == ApiUrls.losers) return 15;
    if (endpoint == ApiUrls.newCoins) return 20;
    return 10;
  }

  Future<MarketResponseModel> _fetch(
    String endpoint, {
    int? page,
    bool forceRefresh = false,
  }) async {
    final key = page != null ? "$endpoint-page:$page" : endpoint;
    if (!forceRefresh) {
      final cached = _cache[key];
      if (cached != null) {
        final (data, time) = cached;
        final ttl = _getCacheTTL(endpoint);

        if (DateTime.now().difference(time).inSeconds < ttl) {
          LogHelper.log("⚡ CACHE HIT → $key");
          _cache.remove(key);
          _cache[key] = (data, time);
          return data;
        } else {
          _cache.remove(key);
        }
      }
    }

    if (forceRefresh) {
      LogHelper.log("🔄 FORCE REFRESH → $key");
      _cache.remove(key);
    }

    if (_ongoingRequests.containsKey(key)) {
      LogHelper.log("⏳ WAITING EXISTING REQUEST → $key");
      return _ongoingRequests[key]!;
    }

    final future = _callApi(endpoint, page);

    _ongoingRequests[key] = future;

    try {
      final result = await future;

      /// 🔥 Save cache
      _cache[key] = (result, DateTime.now());
      _enforceCacheLimit();

      return result;
    } finally {
      _ongoingRequests.remove(key);
    }
  }

  Future<MarketResponseModel> _callApi(String endpoint, int? page) async {
    LogHelper.log("📡 API CALL → $endpoint page=$page");
    try {
      final res = await _get.getRequest(
        endpoint: endpoint,
        queryParams: page != null ? {"page": page} : null,
      );

      if (res.data == null) {
        throw Exception("Empty response from server");
      }

      final model = MarketResponseModel.fromJson(res.data);
      if (!model.success) {
        throw Exception(
          (model.message ?? "").trim().isNotEmpty
              ? model.message
              : "Something went wrong",
        );
      }
      return model;
    } catch (e) {
      LogHelper.error("❌ API ERROR → $endpoint page=$page | $e");
      rethrow;
    }
  }

  Future<MarketResponseModel> getTrending({bool forceRefresh = false}) =>
      _fetch(ApiUrls.trending, forceRefresh: forceRefresh);

  Future<MarketResponseModel> getGainers({
    int page = 1,
    bool forceRefresh = false,
  }) => _fetch(ApiUrls.gainers, page: page, forceRefresh: forceRefresh);

  Future<MarketResponseModel> getLosers({
    int page = 1,
    bool forceRefresh = false,
  }) => _fetch(ApiUrls.losers, page: page, forceRefresh: forceRefresh);

  Future<MarketResponseModel> getAllCoins({
    int page = 1,
    bool forceRefresh = false,
  }) => _fetch(ApiUrls.allCoins, page: page, forceRefresh: forceRefresh);

  Future<MarketResponseModel> getNewCoins({
    int page = 1,
    bool forceRefresh = false,
  }) => _fetch(ApiUrls.newCoins, page: page, forceRefresh: forceRefresh);

  void clearCache() {
    LogHelper.log("🧹 CACHE CLEARED");
    _cache.clear();
  }

  void clearKey(String endpoint, {int? page}) {
    final key = page != null ? "$endpoint-page:$page" : endpoint;
    _cache.remove(key);
  }
}
