
import 'dart:async';
import 'dart:developer' as LogHelper;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/binance/rest/order_book_rest_datasource.dart';
import '../../../data/datasources/binance/socket/binance_socket_service.dart';
import '../../../data/models/binance/order_book_model.dart';

final orderBookProvider =
StreamProvider.family<OrderBookModel, String>(
      (ref, symbol) async* {

    final socket = BinanceSocketService();
    final rest = OrderBookRestDatasource();

    final controller =
    StreamController<OrderBookModel>();

    /// Initial Snapshot
    final snapshot =
    await rest.getOrderBook(symbol);

    final bidsMap = <double, double>{};
    final asksMap = <double, double>{};

    for (final bid in snapshot.bids) {
      bidsMap[bid.price] =
          bid.quantity;
    }

    for (final ask in snapshot.asks) {
      asksMap[ask.price] =
          ask.quantity;
    }

    OrderBookModel buildBook() {

      final bids =
      bidsMap.entries
          .map(
            (e) => OrderBookEntry(
          price: e.key,
          quantity: e.value,
        ),
      )
          .toList()
        ..sort(
              (a, b) =>
              b.price.compareTo(a.price),
        );

      final asks =
      asksMap.entries
          .map(
            (e) => OrderBookEntry(
          price: e.key,
          quantity: e.value,
        ),
      )
          .toList()
        ..sort(
              (a, b) =>
              a.price.compareTo(b.price),
        );

      return OrderBookModel(
        lastUpdateId:
        snapshot.lastUpdateId,
        bids: bids,
        asks: asks,
      );
    }


    /// Emit snapshot first
    controller.add(
      buildBook(),
    );

    socket.connect(
      stream:
      "${symbol.toLowerCase()}@depth20@100ms",
      isFutures: false,
      onData: (data) {

        final update =
        OrderBookModel.fromJson(data);

        for (final bid in update.bids) {

          if (bid.quantity == 0) {
            bidsMap.remove(
              bid.price,
            );
          } else {
            bidsMap[bid.price] =
                bid.quantity;
          }
        }

        for (final ask in update.asks) {

          if (ask.quantity == 0) {
            asksMap.remove(
              ask.price,
            );
          } else {
            asksMap[ask.price] =
                ask.quantity;
          }
        }

        controller.add(
          buildBook(),
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