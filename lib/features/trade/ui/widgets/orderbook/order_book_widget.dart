import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/home_order_book_provider.dart';
import 'current_price_tile.dart';
import 'order_book_row.dart';

class OrderBookWidget extends ConsumerWidget {
  final String symbol;

  const OrderBookWidget({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderBook = ref.watch(homeOrderBookProvider(symbol));
    final dark = Theme.of(context).brightness == Brightness.dark;


    return orderBook.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      data: (book) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: dark
                        ? AppColors.white.withOpacity(.6)
                        : AppColors.black.withOpacity(.6),
                  ),
                ),

                Text(
                  "Amount",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: dark
                        ? AppColors.white.withOpacity(.6)
                        : AppColors.black.withOpacity(.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6,),

            /// ASK
            ListView.builder(
              shrinkWrap: true,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: book.asks.length > 10 ? 10 : book.asks.length,
              itemBuilder: (context, index) {
                final ask = book.asks[index];

                return OrderBookRow(
                  price: ask.price,
                  quantity: ask.quantity,
                  isAsk: true,
                );
              },
            ),

            Center(child:  CurrentPriceTile(symbol: symbol,)),

            /// BID
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: book.bids.length > 10 ? 10: book.bids.length,
              itemBuilder: (context, index) {
                final bid = book.bids[index];

                return OrderBookRow(
                  price: bid.price,
                  quantity: bid.quantity,
                  isAsk: false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}