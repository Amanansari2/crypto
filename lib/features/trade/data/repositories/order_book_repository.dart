import 'dart:async';
import 'dart:convert';

import 'package:crypto_app/features/trade/data/models/orderbook_home/order_book_home_model.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class OrderBookRepository {
  final Dio _dio = Dio();

  WebSocketChannel? _channel;

  /// Initial Snapshot
  Future<OrderBookHomeModel> getSnapshot(String symbol) async {
    final response = await _dio.get(
      'https://api.binance.com/api/v3/depth',
      queryParameters: {
        'symbol': symbol.toUpperCase(),
        'limit': 20,
      },
    );

    return OrderBookHomeModel.fromJson(response.data);
  }

  /// Live OrderBook
  Stream<OrderBookHomeModel> connect(String symbol) {
    _channel?.sink.close();

    _channel = WebSocketChannel.connect(
      Uri.parse(
        'wss://stream.binance.com:9443/ws/${symbol.toLowerCase()}@depth20@100ms',
      ),
    );

    return _channel!.stream.map((event) {
      final json = jsonDecode(event);
      return OrderBookHomeModel.fromJson(json);
    });
  }

  void dispose() {
    _channel?.sink.close();
  }
}