import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
import 'package:crypto_app/features/market/chart_engine/providers/indicators/active_indicators_provider.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/interval/interval_bar.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicator_enable_disable.dart';
import 'package:crypto_app/features/market/ui/widgets/market_detail_widget/last_section/depth/depth_tab.dart';
import 'package:crypto_app/features/market/ui/widgets/market_detail_widget/last_section/info_tab.dart';
import 'package:crypto_app/features/market/ui/widgets/market_detail_widget/last_section/market_details_tabs.dart';
import 'package:crypto_app/features/market/ui/widgets/market_detail_widget/last_section/order_book_tab.dart';
import 'package:crypto_app/features/market/ui/widgets/market_detail_widget/last_section/trades_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../chart_engine/ui/screen/chart_screen.dart';
import '../../chart_engine/ui/widgets/settings/chart_settings_sheet.dart';
import '../../provider/binance/ticker_provider.dart';
import '../widgets/market_detail_widget/last_section/provider/tab_provider.dart';
import '../widgets/market_detail_widget/price_section.dart';
import '../widgets/market_detail_widget/stats_section.dart';

class MarketDetailScreen extends ConsumerStatefulWidget {
  final String symbol;

  const MarketDetailScreen({super.key, required this.symbol});

  @override
  ConsumerState<MarketDetailScreen> createState() => _MarketDetailScreenState();
}

class _MarketDetailScreenState extends ConsumerState<MarketDetailScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final tickerAsync = ref.watch(tickerProvider(widget.symbol));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTab = ref.watch(marketDetailsTabProvider);



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

          final activeIndicators = ref.watch(activeIndicatorsProvider);
final chartHeight = ChartConfig.mainChartHeight
          + ChartConfig.timeAxisHeight
          + (activeIndicators.length * ChartConfig.chartPanelHeight);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  child: Row(
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
                ),
                Divider(
                  color: isDark
                      ? AppColors.blue
                      : AppColors.black,
                ),



                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 4),
                      child: Row(
                        children: [
                          Expanded(
                              child: IntervalBar()
                          ),

                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => const ChartSettingsSheet(),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.blue.withOpacity(0.08)
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.blue.withOpacity(0.4)
                                      : Colors.grey.withOpacity(0.4),
                                ),
                                boxShadow: isDark
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
                              child: Icon(
                              CupertinoIcons.slider_horizontal_3,
                              size: 14,
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                          ),
                          )
                        ],
                      ),
                    ),





                const SizedBox(height: 8,),

                SizedBox(
                  height: chartHeight,
                  child: CustomChartScreen(
                    symbol: widget.symbol,
                  ),
                ),

                const SizedBox(height: 2,),

                IndicatorEnableDisable(),
                const SizedBox(height: 8,),






                MarketDetailsTabs(
                  selectedIndex: selectedTab,
                  onTap: (i) {
                    ref.read(marketDetailsTabProvider.notifier).setTab(i);
                    _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                Divider(
                  color: isDark
                      ? AppColors.blue
                      : AppColors.black,
                ),


                SizedBox(
                  height: 650,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    allowImplicitScrolling: false,
                    controller: _pageController,
                    onPageChanged: (index) {
                      ref.read(marketDetailsTabProvider.notifier).setTab(index);
                    },

                    children: [
                    OrderBookTab(symbol: widget.symbol),
                     DepthTab(symbol: widget.symbol),
                     TradeTab(symbol: widget.symbol),
                    InfoTab(symbol: widget.symbol)
                    ],
                  ),
                ),


              ],
            ),
          );
        },
      ),
    );
  }
}
