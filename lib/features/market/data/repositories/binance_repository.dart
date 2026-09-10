
import 'package:crypto_app/core/network/methods/get_method.dart';
import 'package:crypto_app/core/utils/constants/api_urls.dart';
import 'package:crypto_app/features/market/data/models/pairs_model.dart';

class BinanceRepository {
  final GetMethod _get;

  BinanceRepository({GetMethod? getMethod})
      : _get = getMethod ?? GetMethod();

  Future<List<PairModel>> getPairs() async {
    try {
      final res = await _get.getRequest(
        endpoint: ApiUrls.getPairs,
      );

      if (res.data == null) {
        throw Exception("Empty response from server");
      }

      final response = BinanceResponseModel.fromJson(res.data);

      return response.pairs;
    } catch (e) {
      throw Exception("Failed to fetch Binance pairs: $e");
    }
  }
}