import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../market/ui/widgets/coin_view.dart';
import '../../data/provider/home_market_provider.dart';
import '../widget/drawer/home_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _lastLoadedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadHomeTab(int index) {
    if (index == _lastLoadedIndex) return;

    _lastLoadedIndex = index;

    final notifier = ref.read(homeMarketProvider.notifier);

    switch (index) {
      case 1:
        notifier.loadAll();
        break;
      case 2:
        notifier.loadGainers();
        break;
      case 3:
        notifier.loadLosers();
        break;
      case 4:
        notifier.loadNewCoins();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 6, top: 6, right: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EXISTING SEARCH BAR - UNCHANGED
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(18.r),
                onTap: () {
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
                        color: Colors.black.withOpacity(0.05),
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

            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              labelColor: Colors.blue,
              indicatorColor: Colors.blue,
              splashFactory: NoSplash.splashFactory,
              overlayColor:
              WidgetStateProperty.all(Colors.transparent),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              indicator: UnderlineTabIndicator(
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1.3,
                ),
                insets: EdgeInsets.zero,
              ),
              onTap: _loadHomeTab,
              tabs: const [
                Tab(text: 'Favourite'),
                Tab(text: 'Futures'),
                Tab(text: 'Gainers'),
                Tab(text: 'Losers'),
                Tab(text: 'New'),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox.shrink(),

                  HomeMarketCoinsTab(
                    isDark: isDark,
                    enablePagination: true,
                  ),

                  HomeMarketCoinsTab(
                    isDark: isDark,
                  ),

                  HomeMarketCoinsTab(
                    isDark: isDark,
                  ),

                  HomeMarketCoinsTab(
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class HomeMarketCoinsTab extends ConsumerWidget {
  final bool isDark;
  final bool enablePagination;

  const HomeMarketCoinsTab({
    super.key,
    required this.isDark,
    this.enablePagination = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeMarketProvider);

    return AsyncCoinsView(
      isDark: isDark,
      state: state,
      enablePagination: enablePagination,
      onLoadMore: enablePagination
          ? () {
        ref.read(homeMarketProvider.notifier).loadMore();
      }
          : null,
      onRetry: () async {
        await ref.read(homeMarketProvider.notifier).refresh();
      },
    );
  }
}
