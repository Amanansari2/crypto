import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:crypto_app/features/market/data/models/market_response_model.dart';
import 'package:crypto_app/features/market/ui/shimmers/coin_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../shimmers/pagination_coin_view_shimmer.dart';

class AsyncCoinsView extends StatelessWidget {
  final AsyncValue<MarketResponseModel> state;
  // final VoidCallback? onRetry;
  final Future<void> Function()? onRetry;
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
            onRefresh: ()async{
              if(onRetry !=  null){
                await onRetry!();
              }
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

class PremiumCoinCard extends ConsumerWidget {
  final dynamic coin;

  const PremiumCoinCard({
    super.key,
    required this.coin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final change = coin.priceChangePercentage24h;
    final symbol = coin.symbol.toString().toUpperCase();
    final tradingSymbol = "${symbol}USDT";

    const isAvailable = true;

    return GestureDetector(
      onTap: isAvailable
          ? () {
        context.pushNamed(
          RouteNames.marketDetailName,
          pathParameters: {
            "symbol": tradingSymbol,
          },
        );
      }
          : null,
      child: Opacity(
        opacity: isAvailable ? 1 : 0.5,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 6.w,
            vertical: 4.h,
          ),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),

            // KEEP YOUR EXISTING COLORS
            color: isDark
                ? AppColors.blue.withOpacity(0.08)
                : Colors.white,

            border: Border.all(
              color: isDark
                  ? AppColors.blue.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.4),
            ),
          ),

          child: Column(
            children: [
              /// =========================
              /// TOP SECTION
              /// =========================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// COIN IMAGE
                  Container(
                    width: 40.w,
                    height: 40.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.blue.withOpacity(0.6),
                        width: 1.2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        coin.image,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return Icon(
                            Icons.currency_bitcoin,
                            size: 25.sp,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  /// NAME + PRICE
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        /// NAME + SYMBOL
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                coin.name,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            SizedBox(width: 7.w),

                            Container(
                              padding:
                              EdgeInsets.symmetric(
                                horizontal: 7.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blue
                                    .withOpacity(0.08),
                                borderRadius:
                                BorderRadius.circular(8.r),
                                border: Border.all(
                                  color:  isDark ? AppColors.blue :  AppColors.blue
                                      .withOpacity(0.25),
                                ),
                              ),
                              child: Text(
                                symbol,
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight:
                                  FontWeight.w600,
                                  color: isDark ? AppColors.white : AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 5.h),

                        /// PRICE
                        Text(
                          "\$${_formatPrice(coin.currentPrice)}",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 5.w),

                  /// CHANGE
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: change >= 0
                          ? AppColors.green.withOpacity(0.08)
                          : AppColors.red.withOpacity(0.08),
                      borderRadius:
                      BorderRadius.circular(7.r),
                      border: Border.all(
                        color: change >= 0
                            ? AppColors.green.withOpacity(0.3)
                            : AppColors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          change >= 0
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: 14.sp,
                          color: change >= 0
                              ? AppColors.green
                              : AppColors.red,
                        ),
                        Text(
                          "${change.abs().toStringAsFixed(3)}%",
                          style: TextStyle(
                            color: change >= 0
                                ? AppColors.green
                                : AppColors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 8.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 6.h),

              /// =========================
              /// MARKET DATA
              /// =========================
              Container(
                height: 42.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.blue.withOpacity(0.05)
                      : Colors.grey.withOpacity(0.05),
                  borderRadius:
                  BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.blue.withOpacity(0.25)
                        : Colors.grey.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _marketInfo(
                        "High",
                        _formatPrice(
                          _safeNum(
                                () => coin.highPrice,
                          ),
                        ),
                      ),
                    ),

                    _divider(),

                    Expanded(
                      child: _marketInfo(
                        "Low",
                        _formatPrice(
                          _safeNum(
                                () => coin.lowPrice,
                          ),
                        ),
                      ),
                    ),

                    _divider(),

                    Expanded(
                      child: _marketInfo(
                        "Open",
                        _formatPrice(
                          _safeNum(
                                () => coin.openPrice,
                          ),
                        ),
                      ),
                    ),

                    _divider(),

                    Expanded(
                      child: _marketInfo(
                        "Avg Price",
                        _formatPrice(
                          _safeNum(
                                () => coin.avgPrice,
                          ),
                        ),
                      ),
                    ),

                    _divider(),

                    Expanded(
                      child: _marketInfo(
                        "Volume (24H)",
                        _formatVolume(
                          _safeNum(
                                () => coin.quoteVolume,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =========================
  /// INFO
  /// =========================
  Widget _marketInfo(
      String title,
      String value,
      ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.grey,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// =========================
  /// DIVIDER
  /// =========================
  Widget _divider() {
    return Container(
      width: 1,
      height: 30.h,
      color: Colors.grey.withOpacity(0.15),
    );
  }

  /// =========================
  /// SAFE NUMBER
  /// =========================
  num _safeNum(
      num Function() getter,
      ) {
    try {
      return getter();
    } catch (_) {
      return 0;
    }
  }

  /// =========================
  /// PRICE
  /// =========================
  String _formatPrice(num price) {
    if (price >= 1000) {
      return price
          .toStringAsFixed(2)
          .replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
            (match) => ',',
      );
    }

    if (price >= 1) {
      return price.toStringAsFixed(5);
    }

    return price.toStringAsFixed(5);
  }

  /// =========================
  /// VOLUME
  /// =========================
  String _formatVolume(num value) {
    if (value >= 1000000000) {
      return "${(value / 1000000000).toStringAsFixed(2)}B";
    }

    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(2)}M";
    }

    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(2)}K";
    }

    return value.toStringAsFixed(2);
  }
}