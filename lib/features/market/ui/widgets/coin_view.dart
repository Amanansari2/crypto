import 'package:crypto_app/features/market/ui/shimmers/coin_view_shimmer.dart';
import 'package:crypto_app/features/market/ui/widgets/sparkline_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../domain/entities/market_entity.dart';
import '../shimmers/pagination_coin_view_shimmer.dart';

class AsyncCoinsView extends StatelessWidget {
  final AsyncValue<MarketEntity> state;
  final VoidCallback? onRetry;
  final ScrollController? controller;
  final bool enablePagination;
  final VoidCallback? onLoadMore;
  final bool isDark;

  const AsyncCoinsView({
    super.key,
    required this.state,
    this.onRetry,
    this.controller,
    this.enablePagination = false,
    this.onLoadMore,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => CoinViewShimmer(isDark: isDark),

      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Something went wrong"),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ),
      ),

      data: (data) {
        if (data.coins.isEmpty) {
          return const Center(child: Text("No data"));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (enablePagination &&
                onLoadMore != null &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
              onLoadMore!();
            }
            return false;
          },
          child: RefreshIndicator(
            color: isDark ? Colors.blue.withOpacity(0.6) : Colors.blue,
            backgroundColor: isDark
                ? AppColors.blue.withOpacity(0.8)
                : AppColors.white.withOpacity(0.8),
            onRefresh: () async {
              onRetry?.call();
              await Future.delayed(const Duration(milliseconds: 200));
            },
            child: ListView.builder(
              key: PageStorageKey("coins_list"),
              controller: controller,
              itemCount: data.coins.length + (enablePagination ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == data.coins.length) {
                  return PaginationCoinViewShimmer(isDark: isDark);
                }

                final coin = data.coins[i];

                return PremiumCoinCard(coin: coin);
              },
            ),
          ),
        );
      },
    );
  }
}

class PremiumCoinCard extends StatelessWidget {
  final dynamic coin;

  const PremiumCoinCard({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final change = coin.change24h;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),

        /// 🔥 background
        color: isDark ? AppColors.blue.withOpacity(0.08) : Colors.white,

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
        children: [
          /// 🔝 Top Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  coin.image,
                  height: 26.h,
                  width: 26.h,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    Text(
                      "\$${_formatPrice(coin.price)}",
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 5.w),

              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 30.h,
                  child: SparklineChart(
                    data: coin.sparklines,
                    isPositive: change >= 0,
                    change: change,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              Column(
                children: [
                  Text(
                    coin.symbol,
                    style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: change >= 0
                          ? AppColors.green.withOpacity(0.08)
                          : AppColors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: change >= 0
                            ? AppColors.green.withOpacity(0.3)
                            : AppColors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      "${change.toStringAsFixed(2)}%",
                      style: TextStyle(
                        color: change >= 0 ? AppColors.green : AppColors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 6.sp,
                      ),
                    ),
                  ),
                ],
              ),

              // rank badge
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              //   decoration: BoxDecoration(
              //     color: isDark
              //         ? AppColors.blue.withOpacity(0.15)
              //         : Colors.blue.shade50,
              //     borderRadius: BorderRadius.circular(6.r),
              //     border: Border.all(
              //       color: isDark
              //           ? AppColors.blue.withOpacity(0.4)
              //           : Colors.blue.shade100,
              //     ),
              //   ),
              //   child: Text(
              //     "#${coin.rank}",
              //     style: TextStyle(
              //       fontSize: 10.sp,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),

          /// 📊 Market Data
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _info("MCap", coin.marketCap),
              _info("Vol", coin.volume),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 Helper widget
  Widget _info(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 8.sp, color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  /// 💰 Format price
  String _formatPrice(num price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }
}
