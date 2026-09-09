import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/order_book_home_provider.dart';
import 'current_price_tile.dart';
import 'order_book_header.dart';
import 'order_book_row.dart';

class OrderBookWidget extends ConsumerWidget {
  final String symbol;

  const OrderBookWidget({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderBook = ref.watch(orderBookHomeProvider(symbol));

    return orderBook.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      data: (book) {
        return Column(
          children: [
            const OrderBookHeader(),

            /// ASK
            Expanded(
              child: ListView.builder(
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: book.asks.length,
                itemBuilder: (context, index) {
                  final ask = book.asks[index];

                  return OrderBookRow(
                    price: ask.price,
                    quantity: ask.quantity,
                    isAsk: true,
                  );
                },
              ),
            ),

            const CurrentPriceTile(),

            /// BID
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: book.bids.length,
                itemBuilder: (context, index) {
                  final bid = book.bids[index];

                  return OrderBookRow(
                    price: bid.price,
                    quantity: bid.quantity,
                    isAsk: false,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}