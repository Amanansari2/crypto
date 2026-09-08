import '../../../../../core/network/websocket/trading_backend_socket_service.dart';
import '../models/binance/binance_ticker_model.dart';

class TickerRepository {
  final TradingBackendSocketService _socket =
  TradingBackendSocketService();

  Stream<BinanceTickerModel> ticker(String symbol) {
    final normalizedSymbol = symbol.toUpperCase();
    _socket.subscribeSharedMarketData(normalizedSymbol);

    return _socket.messages
        .where((message) =>
    message['type'] == 'SHARED_MARKET_DATA' &&
        message['data'] != null &&
        message['data']['symbol'] == normalizedSymbol)
        .map((message) =>
        BinanceTickerModel.fromJson(message['data']));
  }

  void unsubscribe(String symbol) {
    _socket.unsubscribeSharedMarketData(symbol);
  }
}