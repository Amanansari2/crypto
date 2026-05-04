import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../provider/binance/ticker_provider.dart';
import '../widgets/market_detail_widget/price_section.dart';
import '../widgets/market_detail_widget/stats_section.dart';

class MarketDetailScreen extends ConsumerStatefulWidget {
  final String symbol;

  const MarketDetailScreen({super.key, required this.symbol});

  @override
  ConsumerState<MarketDetailScreen> createState() => _MarketDetailScreenState();
}

class _MarketDetailScreenState extends ConsumerState<MarketDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final tickerAsync = ref.watch(tickerProvider(widget.symbol));
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;




    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
        centerTitle: false,
      ),
      body:
      tickerAsync.when(
        loading: () => const Center(child: Text("Connecting....")),
        error: (e, _) => Center(
          child: Text(
            "Error: $e",
            style: const TextStyle(color: AppColors.red),
          ),
        ),
        data: (ticker) {



          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PriceSection(ticker: ticker,),
                          SizedBox(height: 8.h,),
                          Row(
                            children: [
                              Text(
                                "Bid : ",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: isDark ? Colors.grey.shade400 : Colors
                                      .grey.shade600,
                                ),
                              ),

                              Text(
                                "${ticker.bid}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.green,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(flex: 3, child: StatsSection(data: ticker)),

                  ],
                ),
                Divider()
              ],
            ),
          );
        },
      ),
    );
  }
}
