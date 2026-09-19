import '../../../../core/network/websocket/trading_backend_socket_service.dart';
import '../../../market/data/models/order_book_model.dart';

class HomeOrderBookRepository {
  final TradingBackendSocketService _socket =
  TradingBackendSocketService();

  Stream<OrderBookModel> orderBook(String symbol) {
    final normalizedSymbol = symbol.toUpperCase();

    _socket.subscribeOrderBook(
      normalizedSymbol,
      "HOME",
    );

    return _socket.messages
        .where(
          (message) =>
      message['type'] == 'ORDER_BOOK' &&
          message['data'] != null &&
          message['data']['symbol'] == normalizedSymbol,
    )
        .map(
          (message) =>
          OrderBookModel.fromJson(message['data']),
    );
  }

  void unsubscribe(String symbol) {
    _socket.unsubscribeOrderBook(
      symbol.toUpperCase(),
      "HOME",
    );
  }
}