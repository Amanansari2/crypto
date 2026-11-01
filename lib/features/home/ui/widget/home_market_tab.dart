
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../market/ui/widgets/coin_view.dart';
import '../../data/provider/home_market_provider.dart';

class HomeMarketTab extends ConsumerStatefulWidget {
  final bool isDark;

  const HomeMarketTab({
    super.key,
    required this.isDark,
  });

  @override
  ConsumerState<HomeMarketTab> createState() => _HomeMarketTabState();
}

class _HomeMarketTabState extends ConsumerState<HomeMarketTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _lastLoadedIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 5,
      vsync: this,
    );

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    final index = _tabController.index;

    if (index == _lastLoadedIndex) return;

    _loadHomeTab(index);
  }

  void _loadHomeTab(int index) {
    if (index == 0) return;

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
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
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
                isDark: widget.isDark,
                enablePagination: true,
              ),

              HomeMarketCoinsTab(
                isDark: widget.isDark,
              ),

              HomeMarketCoinsTab(
                isDark: widget.isDark,
              ),

              HomeMarketCoinsTab(
                isDark: widget.isDark,
              ),
            ],
          ),
        ),
      ],
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
