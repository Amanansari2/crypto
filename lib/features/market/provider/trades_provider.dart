import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/websocket/trading_backend_socket_service.dart';
import '../data/models/trade_model.dart';

final tradeProvider =
StreamProvider.autoDispose.family<
    List<TradeModel>,
    String>(
      (ref, symbol) async* {

    final socket =
    TradingBackendSocketService();

    final controller =
    StreamController<
        List<TradeModel>>();

    final trades =
    <TradeModel>[];

    socket.subscribeTrades(
      symbol,
    );

    final subscription =
    socket.messages
        .where(
          (message) =>
      message['type'] == 'TRADE' &&
          message['data'] != null &&
          message['data']['symbol'] ==
              symbol.toUpperCase(),
    )
        .listen(
          (message) {

        final trade =
        TradeModel.fromJson(
          message['data'],
        );

        trades.insert(
          0,
          trade,
        );

        if (
        trades.length > 100
        ) {
          trades.removeLast();
        }

        controller.add(
          List.from(
            trades,
          ),
        );
      },
    );

    ref.onDispose(() {

      subscription.cancel();

      socket.unsubscribeTrades(
        symbol,
      );

      controller.close();
    });

    yield* controller.stream;
  },
);