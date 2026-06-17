import 'package:crypto_app/core/utils/constants/api_urls.dart';

import '../../../../../../core/network/methods/get_method.dart';
import '../../../models/binance/order_book_model.dart';

class OrderBookRestDatasource {

  final GetMethod _getMethod = GetMethod();

  Future<OrderBookModel> getOrderBook(
      String symbol,
      ) async {

    final response =
    await _getMethod.getRequest(
      endpoint:
      "${ApiUrls.getOrderBook}/$symbol"
    );

    return OrderBookModel.fromJson(
      response.data["data"],
    );
  }
}