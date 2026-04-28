import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:crypto_app/core/utils/constants/app_strings.dart';
import 'package:crypto_app/features/market/ui/shimmers/trending_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../provider/market_provider.dart';
import '../../provider/tab_notifier.dart';
import '../widgets/coin_view.dart';
import '../widgets/market_tabs.dart';
import '../widgets/sparkline_chart.dart';

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

    final trending = ref.watch(trendingCoinsProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Market"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.trendingCoins,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),

            SizedBox(height: 4.h),

            SizedBox(
              height: 130.h,
              child: trending.when(
                data: (data) {
                  final coins = data.coins;
                  if (coins.isEmpty) {
                    return const Center(child: Text("No trending coins"));
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: coins.length,
                    itemBuilder: (_, i) {
                      final coin = coins[i];
                      final change = coin.change24h;

                      return Container(
                        width: 140.w,
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
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// 🔝 Top Row (Image + Rank)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(coin.image, height: 25.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.blue.withOpacity(0.15)
                                            : Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),

                                        border: Border.all(
                                          color: isDark
                                              ? AppColors.blue.withOpacity(0.4)
                                              : Colors.blue.shade100,
                                        ),
                                      ),
                                      child: Text(
                                        "#${coin.rank}",
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),

                                    Text(
                                      coin.symbol,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 8.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Text(
                              coin.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10.sp,
                              ),
                            ),

                            SparklineChart(
                              data: coin.sparklines,
                              isPositive: coin.change24h >= 0,
                              change: coin.change24h,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// 💰 Price
                                Text(
                                  "\$ ${coin.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                /// 📊 Change %
                                Text(
                                  "${change.toStringAsFixed(2)}%",
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
              onTap: (i) {
                ref.read(marketTabProvider.notifier).setTab(i);
                _pageController.animateToPage(
                  i,
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
                },

                children: [
                  _allCoinsView(isDark),
                  _gainersView(isDark),
                  _losersView(isDark),
                  _newCoinsView(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _allCoinsView(bool isDark) {
    final state = ref.watch(allCoinsProvider);

    return AsyncCoinsView(
      isDark: isDark,
      state: state,
      enablePagination: true,
      onLoadMore: () {
        ref.read(allCoinsProvider.notifier).loadMore();
      },
      onRetry: () {
        ref.read(allCoinsProvider.notifier).refresh();
      },
    );
  }

  Widget _gainersView(bool isDark) {
    final tabNotifier = ref.watch(marketTabProvider.notifier);

    if (!tabNotifier.isLoaded(1)) {
      return const Center(child: CircularProgressIndicator());
    }

    final state = ref.watch(gainersProvider);

    return AsyncCoinsView(
      isDark: isDark,
      state: state,
      onRetry: () {
        ref.invalidate(gainersProvider);
      },
    );
  }

  Widget _losersView(bool isDark) {
    final tabNotifier = ref.watch(marketTabProvider.notifier);

    if (!tabNotifier.isLoaded(2)) {
      return const Center(child: CircularProgressIndicator());
    }
    final state = ref.watch(losersProvider);

    return AsyncCoinsView(
      isDark: isDark,
      state: state,
      onRetry: () {
        ref.invalidate(losersProvider);
      },
    );
  }

  Widget _newCoinsView(bool isDark) {
    final tabNotifier = ref.watch(marketTabProvider.notifier);

    if (!tabNotifier.isLoaded(3)) {
      return const Center(child: CircularProgressIndicator());
    }
    final state = ref.watch(newCoinProvider);

    return AsyncCoinsView(
      isDark: isDark,
      state: state,
      onRetry: () {
        ref.invalidate(newCoinProvider);
      },
    );
  }
}
