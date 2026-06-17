import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/binance/socket/binance_socket_service.dart';
import '../../data/models/binance/trade_model.dart';

final tradeProvider =
StreamProvider.family<
    List<TradeModel>,
    String>(
      (ref, symbol) async* {

    final socket =
    BinanceSocketService();

    final controller =
    StreamController<
        List<TradeModel>>();

    final trades =
    <TradeModel>[];

    socket.connect(
      stream:
      "${symbol.toLowerCase()}@aggTrade",
      onData: (data) {

        final trade =
        TradeModel.fromJson(
          data,
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

      socket.disconnect(
        "${symbol.toLowerCase()}@aggTrade",
      );

      controller.close();
    });

    yield* controller.stream;
  },
);