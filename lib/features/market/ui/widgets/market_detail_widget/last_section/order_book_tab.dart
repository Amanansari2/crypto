
import 'dart:math' as math;

import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:crypto_app/features/market/provider/binance/orderbook/order_book_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/binance/order_book_model.dart';
import '../../../../provider/binance/orderbook/order_book_step_provider.dart';


class OrderBookTab extends ConsumerWidget {
  final String symbol;

  const OrderBookTab({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderBookAsync = ref.watch(
      orderBookProvider(symbol),
    );

    final step =
    ref.watch(
      orderBookStepProvider,
    );


     final dark =
        Theme.of(context).brightness == Brightness.dark;

    return orderBookAsync.when(
      loading: () =>
      const Center(child: CircularProgressIndicator()),

      error: (e, _) => Center(
        child: Text(
          e.toString(),
        ),
      ),

      data: (data) {

        final sourceCount = step == 0.1 ? 500 : step == 1 ? 1000 : 2000;

        const visibleRows = 40;



        final bids = aggregateLevels(
          data.bids.take(sourceCount).toList(),
          step,
        ).take(visibleRows).toList();

        final asks = aggregateLevels(
          data.asks.take(sourceCount).toList(),
          step,
        ).take(visibleRows).toList();

        final cumulativeBids = <double>[];
        double bidRunning = 0;

        for (final bid in bids) {
          bidRunning += bid.quantity;
          cumulativeBids.add(bidRunning);
        }



        final cumulativeAsks = <double>[];
        double askRunning = 0;

        for (final ask in asks) {
          askRunning += ask.quantity;
          cumulativeAsks.add(askRunning);
        }
       final maxBidDepth =
        cumulativeBids.reduce(math.max);

        final maxAskDepth =
        cumulativeAsks.reduce(math.max);

        return Column(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              child: Row(
                children: [

                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Buy',
                      style: TextStyle(
                          fontSize: 14
                      ),
                    ),
                  ),

                  const Expanded(
                    flex: 5,
                    child: Center(
                      child: Text(
                        'Sell',
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),

                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: (){
                       _showDepthPicker(context, ref);
                      },
                      child: Container(
                        height: 26.h,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6, ),

                        decoration: BoxDecoration(
                          color: dark
                              ? AppColors.blue.withOpacity(0.08)
                              : AppColors.white,

                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: dark
                                ? AppColors.blue.withOpacity(0.4)
                                : Colors.grey.withOpacity(0.4),
                          ),
                          boxShadow: dark
                              ? []
                              : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children:  [
                            Text(step.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 4.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Amount(USDT)",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      "Price(USDT)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),



                  Expanded(
                    child: Text(
                      "Amount(USDT)",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: math.min(bids.length, asks.length),
                itemBuilder: (_, index) {

                final bid = bids[index];
                  final ask = asks[index];



                  final bidDepth =
                  cumulativeBids[ index];

                  final askDepth = cumulativeAsks[ index];
                  final globalMaxDepth =
                  maxBidDepth > maxAskDepth
                      ? maxBidDepth
                      : maxAskDepth;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      height: 14.h,
                      child: Stack(
                        children: [

                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FractionallySizedBox(
                                  widthFactor:

                                      math.sqrt(
                                        askDepth / globalMaxDepth,
                                  ).clamp(0.0, 1.0),
                                  child: Container(
                                    color: AppColors.green.withOpacity(
                                      dark ? 0.4 : 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),


                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor:
                                  math.sqrt(
                                    bidDepth / globalMaxDepth,
                                  ).clamp(0.0, 1.0),
                                  child: Container(
                                    color: AppColors.red.withOpacity(
                                      dark ? 0.12 : 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  bid.quantity.toStringAsFixed(4),
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Align(
                                    alignment: AlignmentGeometry.centerRight,
                                    child: Text(
                                      bid.price
                                          .toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        color: AppColors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Align(
                                    alignment: AlignmentGeometry.centerLeft,
                                    child: Text(
                                      ask.price
                                          .toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 3,
                                child: Text(
                                  ask.quantity
                                      .toStringAsFixed(4),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDepthPicker(
      BuildContext context,
      WidgetRef ref
      ) {
    final values = [
      '0.1',
      '1',
      '10',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {

        final dark = Theme.of(context).brightness == Brightness.dark;


        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),

          decoration:
          BoxDecoration(
            color: dark? AppColors.darkBg : AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                18,
              ),
            ),
          ),

          child: Column(
            children: [

              const SizedBox(
                height: 12,
              ),

              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius:
                  BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {

                    final selected =
                    ref.watch(
                      orderBookStepProvider,
                    );

                    return Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: values.map((e) {

                        final value =
                        double.parse(e);

                        final isSelected =
                            selected == value;

                        return InkWell(
                          onTap: () {

                            ref
                                .read(
                              orderBookStepProvider
                                  .notifier,
                            )
                                .changeStep(
                              value,
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            alignment:
                            Alignment.center,
                            child: Text(
                              e,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),


              SizedBox(height: 20,),

              GestureDetector(

                onTap: () {
                  Navigator.pop(context);
                },

                child: Container(
                  height: 40,
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 12,
                  ),

                  decoration: BoxDecoration(
                    color: dark
                        ? AppColors.blue.withOpacity(0.08)
                        : AppColors.white,

                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: dark
                          ? AppColors.blue.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.4),
                    ),
                    boxShadow: dark
                        ? []
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),


                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}




List<OrderBookEntry> aggregateLevels(
    List<OrderBookEntry> levels,
    double step,
    ) {
  final map = <double, double>{};

  for (final level in levels) {

    final bucket =
        (level.price / step).floor() * step;

    map[bucket] =
        (map[bucket] ?? 0) +
            level.quantity;
  }

  final result = map.entries
      .map(
        (e) => OrderBookEntry(
      price: e.key,
      quantity: e.value,
    ),
  )
      .toList();

  result.sort(
        (a, b) => b.price.compareTo(a.price),
  );

  return result;
}