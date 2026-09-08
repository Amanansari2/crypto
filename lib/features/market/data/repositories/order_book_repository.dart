import '../../../../../core/network/websocket/trading_backend_socket_service.dart';
import '../models/binance/order_book_model.dart';

class OrderBookRepository {
  final TradingBackendSocketService _socket =
  TradingBackendSocketService();

  Stream<OrderBookModel> orderBook(String symbol) {
    final normalizedSymbol = symbol.toUpperCase();

    _socket.subscribeOrderBook(normalizedSymbol);

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
    _socket.unsubscribeOrderBook(symbol);
  }
}