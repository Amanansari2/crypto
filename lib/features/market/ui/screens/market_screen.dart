import 'package:crypto_app/app/router/route_names.dart';
import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:crypto_app/core/utils/constants/app_strings.dart';
import 'package:crypto_app/features/market/provider/trending_provider.dart';
import 'package:crypto_app/features/market/ui/shimmers/trending_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../provider/market_provider.dart';
import '../../provider/tab_notifier.dart';
import '../widgets/coin_view.dart';
import '../widgets/market_tabs.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
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
    final selectedTab = ref.watch(marketTabProvider);

    // final combined = ref.watch(combinedMarketProvider);
    final trending = ref.watch(trendingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text("Market", style: TextStyle(color: isDark ? AppColors.white : AppColors.black),), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(18.r),
                onTap: (){
                  context.pushNamed(RouteNames.marketSearchName);
                },
                child: Container(
                  height: 42.h,
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    color: isDark
                        ? AppColors.blue.withOpacity(0.08)
                        : AppColors.white,
                
                    border: Border.all(
                      color: isDark
                          ? AppColors.blue.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.4),
                    ),
                
                    boxShadow: isDark
                        ? []
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.05,
                        ),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 18.sp,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Search coins, symbol or name...",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 8.h),




            Text(
              AppStrings.trendingCoins,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),

            SizedBox(height: 4.h),

            SizedBox(
              height: 150.h,
              child: trending.when(
                data: (data) {
                  final coins = data.coins;
                  // final pairs = data.pairs;
                  if (coins.isEmpty) {
                    return const Center(child: Text(AppStrings.noTrending));
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: coins.length,
                    itemBuilder: (_, i) {
                      final coin = coins[i];
                      final change = coin.priceChangePercentage24h;
                      final symbol = coin.symbol.toUpperCase() + "USDT";

                      // final isAvailable =
                      // pairs.any((p) => p.symbol == symbol);

                      const isAvailable = true;
                      return GestureDetector(
                        onTap: isAvailable
                            ? () {
                                context.pushNamed(
                                  RouteNames.marketDetailName,
                                  pathParameters: {"symbol": symbol},
                                );
                              }
                            : null,
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: isAvailable ? 1 : 0.5,
                              child: Container(
                                width: 160.w,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.h,
                                ),
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.r),
                                  color: isDark
                                      ? AppColors.blue.withOpacity(0.08)
                                      : AppColors.white,

                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.blue.withOpacity(0.4)
                                        : Colors.grey.withOpacity(0.4),
                                  ),

                                  boxShadow: isDark
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// 🔝 Top Row (Image + Rank)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(coin.image, height: 25.h),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                coin.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp,
                                                ),
                                              ),

                                              Text(
                                                coin.symbol,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h),

                                    Text(
                                      "\$ ${coin.currentPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Divider(thickness: 0.2),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.bar_chart_outlined),

                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "24h Volume",
                                                style: TextStyle(
                                                  fontSize: 8.sp,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                ),
                                              ),

                                              SizedBox(height: 2.h),

                                              Text(
                                                coin.quoteVolume,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "(24h)",
                                                style: TextStyle(
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 8.sp,
                                                ),
                                              ),

                                              SizedBox(height: 2.h),

                                              Text(
                                                "${change.toStringAsFixed(3)}%",
                                                style: TextStyle(
                                                  color: change >= 0
                                                      ? AppColors.green
                                                      : AppColors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Divider(thickness: 0.2),

                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Text(
                                                "(24 high)",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                ),
                                              ),

                                              SizedBox(height: 2.h),

                                              Text(
                                                coin.highPrice.toStringAsFixed(
                                                  2,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Text(
                                                "(24 low)",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                ),
                                              ),
                                              SizedBox(height: 2.h),

                                              Text(
                                                coin.lowPrice.toStringAsFixed(
                                                  2,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Open Price",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                coin.openPrice.toStringAsFixed(
                                                  2,
                                                ),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },

                loading: () => TrendingShimmer(isDark: isDark),

                error: (e, _) => Center(
                  child: Text(
                    "Failed to load",
                    style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Divider(
                color: isDark
                    ? AppColors.blue.withOpacity(0.80)
                    : AppColors.black.withOpacity(0.30),
              ),
            ),

            MarketTabs(
              selectedIndex: selectedTab,
              onTap: (index) {
                ref.read(marketTabProvider.notifier).setTab(index);


                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),

            const SizedBox(height: 8),

            /// 🔥 Coin List
            Expanded(
              child: PageView(
                physics: BouncingScrollPhysics(),
                allowImplicitScrolling: false,
                controller: _pageController,
                onPageChanged: (index) {
                  ref.read(marketTabProvider.notifier).setTab(index);

                  final notifier = ref.read(marketProvider.notifier);

                  switch (index) {
                    case 0:
                      notifier.loadAll();
                      break;
                    case 1:
                      notifier.loadGainers();
                      break;
                    case 2:
                      notifier.loadLosers();
                      break;
                    case 3:
                      notifier.loadNewCoins();
                      break;
                  }
                },

                children: List.generate(4, (_) => _coinsView(isDark)),
                // ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coinsView(bool isDark) {
    final state = ref.watch(marketProvider);
    final selectedTab = ref.watch(marketTabProvider);

    return AsyncCoinsView(
      isDark: isDark,
      state: state,
      enablePagination: selectedTab == 0,
      onLoadMore: () {
        ref.read(marketProvider.notifier).loadMore();
      },
      onRetry: () async {
        ref.invalidate(trendingProvider);

        await Future.wait([
          ref.read(marketProvider.notifier).refresh(),
          ref.read(trendingProvider.future),
        ]);
      },
    );
  }
}
