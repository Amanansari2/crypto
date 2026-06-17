import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/binance/socket/binance_socket_service.dart';
import '../../data/models/binance/order_book_model.dart';

final depthProvider =
StreamProvider.family<OrderBookModel, String>(
      (ref, symbol) async* {
    final socket = BinanceSocketService();

    final controller =
    StreamController<OrderBookModel>();

    socket.connect(
      stream:
      "${symbol.toLowerCase()}@depth20@100ms",
      isFutures: false,
      onData: (data) {
        final update =
        OrderBookModel.fromJson(data);

        final bids = update.bids.toList()
          ..sort(
                (a, b) =>
                b.price.compareTo(a.price),
          );

        final asks = update.asks.toList()
          ..sort(
                (a, b) =>
                a.price.compareTo(b.price),
          );

        controller.add(
          OrderBookModel(
            lastUpdateId:
            update.lastUpdateId,
            bids: bids,
            asks: asks,
          ),
        );
      },
    );

    ref.onDispose(() {
      socket.disconnect(
        "${symbol.toLowerCase()}@depth20@100ms",
      );

      controller.close();
    });

    yield* controller.stream;
  },
);