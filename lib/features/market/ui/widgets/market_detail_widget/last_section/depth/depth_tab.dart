import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../provider/binance/depth_provider.dart';
import 'depth_painter.dart';
import 'depth_point.dart';

class DepthTab extends ConsumerWidget {
  final String symbol;

  const DepthTab({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final depthAsync =
    ref.watch(depthProvider(symbol));

    return depthAsync.when(

      loading: () =>
      const Center(
        child: CircularProgressIndicator(),
      ),

      error: (e, _) =>
          Center(
            child: Text(e.toString()),
          ),

      data: (book) {

        final bids =
        book.bids.toList();

        final asks =
        book.asks.toList();

        double bidCum = 0;

        final bidPoints =
        bids.reversed.map((e) {

          bidCum += e.quantity;

          return DepthPoint(
            price: e.price,
            volume: bidCum,
          );

        }).toList();

        double askCum = 0;

        final askPoints =
        asks.map((e) {

          askCum += e.quantity;

          return DepthPoint(
            price: e.price,
            volume: askCum,
          );

        }).toList();



        return SizedBox(
          height: 220,
          width: double.infinity,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: DepthPainter(
                bids: bidPoints,
                asks: askPoints,
              ),
              size: Size.infinite,
            ),
          ),
        );
      },
    );
  }
}