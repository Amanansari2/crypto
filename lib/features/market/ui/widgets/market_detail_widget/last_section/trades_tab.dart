import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../provider/binance/trades_provider.dart';

class TradeTab extends ConsumerWidget {
  final String symbol;

  const TradeTab({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final dark = Theme.of(context).brightness == Brightness.dark;

    final tradesAsync = ref.watch(
      tradeProvider(symbol),
    );



    return tradesAsync.when(
      data: (trades) {
        return Column(
          children: [

            /// HEADER
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: const Row(
                children: [

                  Expanded(
                    flex: 3,
                    child: Text(
                      "Time",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Text(
                      "Side",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Text(
                      "Price",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Text(
                      "Amount(BTC)",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 12,
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
                padding: EdgeInsets.zero,
                itemCount: trades.length,
                itemBuilder: (
                    context,
                    index,
                    ) {

                  final trade =
                  trades[index];

                  final color =
                  trade.isSell
                      ? AppColors.red
                      : AppColors.green;

                  return Container(
                    height: 26,
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Row(
                      children: [

                        /// TIME
                        Expanded(
                          flex: 3,
                          child: Text(
                            DateFormat(
                              "HH:mm:ss",
                            ).format(
                              DateTime.fromMillisecondsSinceEpoch(
                                trade.time,
                              ),
                            ),
                            style:
                            const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ),

                        /// SIDE
                        Expanded(
                          flex: 2,
                          child: Text(
                            trade.isSell
                                ? "Sell"
                                : "Buy",
                            style:
                            TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ),

                        /// PRICE
                        Expanded(
                          flex: 3,
                          child: Text(
                            trade.price
                                .toStringAsFixed(
                              1,
                            ),
                            textAlign:
                            TextAlign.center,
                            style:
                            TextStyle(
                              wordSpacing: 1,
                              fontSize: 11,
                              color: color,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        /// AMOUNT
                        Expanded(
                          flex: 3,
                          child: Text(
                            trade.quantity
                                .toStringAsFixed(
                              4,
                            ),
                            textAlign:
                            TextAlign.end,
                            style:
                            const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },

      loading: () => const Center(
        child:
        CircularProgressIndicator(),
      ),

      error: (e, _) => Center(
        child: Text(
          e.toString(),
        ),
      ),
    );
  }
}