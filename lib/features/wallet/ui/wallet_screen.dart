
import 'package:crypto_app/features/wallet/ui/widget/wallet_overview_tab.dart';
import 'package:crypto_app/features/wallet/ui/widget/wallet_trade_history_tab.dart';
import 'package:crypto_app/features/wallet/ui/widget/wallet_transaction_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/theme_mode_chip.dart';
import '../data/provider/wallet_overview_provider.dart';

class WalletScreen extends ConsumerStatefulWidget {
  final String accountId;

  const WalletScreen({
    super.key,
    this.accountId = 'DEMO001',
  });

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref
          .read(walletOverviewProvider.notifier)
          .getWalletOverview(widget.accountId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletOverviewProvider);
    final wallet = walletState.wallet;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(walletOverviewProvider.notifier)
                  .refresh(widget.accountId);
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh wallet',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref
              .read(walletOverviewProvider.notifier)
              .refresh(widget.accountId),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(16.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (walletState.isLoading && wallet == null)
                      const LinearProgressIndicator(),

                    if (walletState.error != null && wallet == null) ...[
                      SizedBox(height: 24.h),
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, size: 40),
                            SizedBox(height: 8.h),
                            Text(
                              walletState.error!,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            FilledButton(
                              onPressed: () {
                                ref
                                    .read(walletOverviewProvider.notifier)
                                    .refresh(widget.accountId);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (wallet != null) ...[

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(22.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? const [
                              Color(0xFF172438),
                              Color(0xFF101B2D),
                              Color(0xFF0D1626),
                            ]
                                : [
                                  Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.78),]
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: isDark ? 0.08 : 0.16,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF243B55).withValues(
                                alpha: isDark ? 0.20 : 0.14,
                              ),
                              blurRadius: 22,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(9.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.08),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    'Total Wallet Balance',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.82),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.08),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 7.w,
                                        height: 7.w,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF5FE0A0),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        wallet.status,
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${wallet.balance.toStringAsFixed(2)} ${wallet.currency}',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16,),


                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _WalletMetricCard(
                              title: 'Available Balance',
                              value: _formatAmount(wallet.availableBalance),
                              icon: Icons.account_balance_wallet_outlined,
                            ),
                          ),
                          Expanded(
                            child: _WalletMetricCard(
                              title: 'Used Margin',
                              value: _formatAmount(wallet.usedMargin),
                              icon: Icons.pie_chart_outline,
                            ),
                          ),
                          Expanded(
                            child: _WalletMetricCard(
                              title: 'Realized PnL',
                              value: _formatAmount(wallet.realizedPnl),
                              icon: Icons.trending_up,
                            ),
                          ),
                          Expanded(
                            child: _WalletMetricCard(
                              title: 'Fees',
                              value: _formatAmount(wallet.totalFees),
                              icon: Icons.receipt_long_outlined,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),

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
                            width: 1.3, // Ultra-thin line
                          ),
                          insets: EdgeInsets.zero,
                        ),

                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Transactions'),
                          Tab(text: 'Trade History'),
                        ],
                      ),

                      SizedBox(
                        height: 420.h,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            WalletOverviewTab(
                              transactions: wallet.recentTransactions,
                            ),
                            WalletTransactionsTab(
                              accountId: widget.accountId,
                            ),
                            WalletTradeHistoryTab(
                              accountId: widget.accountId,
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (walletState.isLoading && wallet != null)
                      const LinearProgressIndicator(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _WalletMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _WalletMetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  Color _getAccentColor() {
    switch (title.toLowerCase()) {
      case 'available balance':
        return  Colors.green;
      case 'used margin':
        return  Colors.deepOrange;
      case 'realized pnl':
        return  Colors.orange;
      case 'fees':
        return  Colors.cyan;
      default:
        return  Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = _getAccentColor();

    final displayValue = title.toLowerCase().contains('pnl')
        ? value
        : value;

    final isNegativePnl = title.toLowerCase().contains('pnl') &&
        displayValue.trimLeft().startsWith('-');

    final valueColor = isNegativePnl
        ?  Colors.red
        : isDark
        ? const Color(0xFFF1F4FA)
        : const Color(0xFF17263B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.10),
            shape: BoxShape.circle,
            border: Border.all(
              color: accent.withValues(alpha: 0.60),
            ),
          ),
          child: Icon(
            icon,
            size: 19.sp,
            color: accent,
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
           overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 8.sp,
            color: isDark
                ? const Color(0xFFABB6C8)
                : const Color(0xFF6B7789),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: valueColor,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }
}


