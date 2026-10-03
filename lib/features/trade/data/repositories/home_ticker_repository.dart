import '../../../../../core/network/websocket/trading_backend_socket_service.dart';
import '../../../market/data/models/binance_ticker_model.dart';

class HomeTickerRepository {
  final TradingBackendSocketService _socket =
  TradingBackendSocketService();

  Stream<BinanceTickerModel> ticker(String symbol) {
    final normalizedSymbol = symbol.toUpperCase();

    _socket.subscribeSharedMarketData(
      normalizedSymbol,
      'HOME',
    );

    return _socket.messages
        .where((message) =>
    message['type'] == 'SHARED_MARKET_DATA' &&
        message['data'] != null &&
        message['data']['symbol'] == normalizedSymbol)
        .map(
          (message) =>
          BinanceTickerModel.fromJson(message['data']),
    );
  }

  void unsubscribe(String symbol) {
    _socket.unsubscribeSharedMarketData(
      symbol.toUpperCase(),
      'HOME',
    );
  }
}