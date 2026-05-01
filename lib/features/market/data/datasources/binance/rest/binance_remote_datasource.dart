import 'package:crypto_app/core/network/methods/get_method.dart';
import 'package:crypto_app/core/utils/constants/api_urls.dart';
import 'package:crypto_app/features/market/data/models/binance/pairs_model.dart';
import 'package:crypto_app/features/market/domain/entities/binance/pair_entity.dart';

class BinanceRemoteDataSource {
  final GetMethod _get;

  BinanceRemoteDataSource({GetMethod? getMethod})
    : _get = getMethod ?? GetMethod();

  Future<List<PairEntity>> getPairs() async {
    final res = await _get.getRequest(endpoint: ApiUrls.getPairs);

    if (res.data == null) {
      throw Exception("Empty response from server");
    }

    final response = BinanceResponseModel.fromJson(res.data);

    return response.pairs;
  }
}
