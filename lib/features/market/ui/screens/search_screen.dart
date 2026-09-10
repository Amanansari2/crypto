import 'dart:async';

import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:crypto_app/features/market/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchController;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();

    final query = value.trim();

    if (query.isEmpty) {
      ref.read(searchProvider.notifier).search('');
      setState(() {});
      return;
    }

    _debounceTimer = Timer(
      const Duration(milliseconds: 350),
          () {
        ref.read(searchProvider.notifier).search(query);
      },
    );

    setState(() {});
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();

    ref.read(searchProvider.notifier).search('');

    setState(() {});
  }

  void _cancelSearch() {
    _debounceTimer?.cancel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 8.w,
        title: Row(
          children: [
            Expanded(
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
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                    filled:  true,
                    fillColor: Colors.transparent,
                    hintText: "Search coins, symbol or name...",
                    hintStyle: TextStyle(
                      fontSize: 11.sp,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 18.sp,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      onPressed: _clearSearch,
                      icon: Icon(
                        Icons.close,
                        size: 17.sp,
                      ),
                    )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 11.h,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 8.w),

            TextButton(
              onPressed: _cancelSearch,
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.white : AppColors.black
                ),
              ),
            ),
          ],
        ),
      ),

      body: Consumer(
        builder: (context, ref, child) {
          final searchState = ref.watch(searchProvider);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: searchState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),

              error: (error, stack) => Center(
                child: Text(
                  "Something went wrong",
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ),

              data: (data) {
                if (data == null) {
                  return const SizedBox.shrink();
                }

                if (data.coins.isEmpty) {
                  return Center(
                    child: Text(
                      "No coins found",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    Text(
                      "Search Results (${data.coins.length})",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.white : AppColors.black
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: data.coins.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 14.h,
                        ),
                        itemBuilder: (context, index) {
                          final coin = data.coins[index];

                          final isPositive =
                              coin.priceChangePercentage24h >= 0;

                          return Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(18.r),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18.r),
                              onTap: () {
                                context.pushNamed(
                                  RouteNames.marketDetailName,
                                  pathParameters: {
                                    'symbol': '${coin.symbol.toUpperCase()}USDT',
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.w),
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            coin.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            coin.symbol.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "\$${coin.currentPrice.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "${isPositive ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: isPositive
                                                ? AppColors.green
                                                : AppColors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}