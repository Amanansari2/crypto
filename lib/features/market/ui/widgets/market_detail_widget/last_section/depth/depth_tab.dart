import 'package:crypto_app/features/market/provider/binance/orderbook/order_book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    ref.watch(orderBookProvider(symbol));

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


        // double bidCum = 0;
        //
        // final bidPoints = <DepthPoint>[];
        //
        // if (bids.isNotEmpty) {
        //   // Center point = 0 volume
        //   bidPoints.add(
        //     DepthPoint(
        //       price: bids.first.price,
        //       volume: 0,
        //     ),
        //   );
        //
        //   for (int i = 1; i < bids.length; i++) {
        //     bidCum += bids[i - 1].quantity;
        //
        //     bidPoints.add(
        //       DepthPoint(
        //         price: bids[i].price,
        //         volume: bidCum,
        //       ),
        //     );
        //   }
        // }
        //
        // double askCum = 0;
        //
        // final askPoints = <DepthPoint>[];
        //
        // if (asks.isNotEmpty) {
        //   // Center point = 0 volume
        //   askPoints.add(
        //     DepthPoint(
        //       price: asks.first.price,
        //       volume: 0,
        //     ),
        //   );
        //
        //   for (int i = 1; i < asks.length; i++) {
        //     askCum += asks[i - 1].quantity;
        //
        //     askPoints.add(
        //       DepthPoint(
        //         price: asks[i].price,
        //         volume: askCum,
        //       ),
        //     );
        //   }
        // }

        const bucketCount = 24;

        final bidPoints = <DepthPoint>[];
        final askPoints = <DepthPoint>[];

        if (bids.isNotEmpty) {
          final bestBid = bids.first.price;
          final lowestBid = bids.last.price;

          final bidRange = bestBid - lowestBid;

          if (bidRange > 0) {
            final bucketSize = bidRange / bucketCount;

            final bucketVolumes =
            List<double>.filled(bucketCount, 0);

            for (final entry in bids) {
              final distance = bestBid - entry.price;

              int bucket =
              (distance / bucketSize).floor();

              if (bucket >= bucketCount) {
                bucket = bucketCount - 1;
              }

              bucketVolumes[bucket] += entry.quantity;
            }

            double cumulative = 0;

            // Center = zero
            bidPoints.add(
              DepthPoint(
                price: bestBid,
                volume: 0,
              ),
            );

            for (int i = 0; i < bucketCount; i++) {
              cumulative += bucketVolumes[i];

              final price =
                  bestBid - ((i + 1) * bucketSize);

              bidPoints.add(
                DepthPoint(
                  price: price,
                  volume: cumulative,
                ),
              );
            }
          }
        }

        if (asks.isNotEmpty) {
          final bestAsk = asks.first.price;
          final highestAsk = asks.last.price;

          final askRange = highestAsk - bestAsk;

          if (askRange > 0) {
            final bucketSize = askRange / bucketCount;

            final bucketVolumes =
            List<double>.filled(bucketCount, 0);

            for (final entry in asks) {
              final distance = entry.price - bestAsk;

              int bucket =
              (distance / bucketSize).floor();

              if (bucket >= bucketCount) {
                bucket = bucketCount - 1;
              }

              bucketVolumes[bucket] += entry.quantity;
            }

            double cumulative = 0;

            // Center = zero
            askPoints.add(
              DepthPoint(
                price: bestAsk,
                volume: 0,
              ),
            );

            for (int i = 0; i < bucketCount; i++) {
              cumulative += bucketVolumes[i];

              final price =
                  bestAsk + ((i + 1) * bucketSize);

              askPoints.add(
                DepthPoint(
                  price: price,
                  volume: cumulative,
                ),
              );
            }
          }
        }



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