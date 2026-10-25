
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../data/model/wallet_trade__history_model.dart';
import '../../data/provider/wallet_trade_history_provider.dart';

class WalletTradeHistoryTab extends ConsumerStatefulWidget {
  final String accountId;

  const WalletTradeHistoryTab({
    super.key,
    required this.accountId,
  });

  @override
  ConsumerState<WalletTradeHistoryTab> createState() =>
      _WalletTradeHistoryTabState();
}

class _WalletTradeHistoryTabState
    extends ConsumerState<WalletTradeHistoryTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref
          .read(walletTradeHistoryProvider.notifier)
          .loadTrades(widget.accountId);
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 150) {
      ref.read(walletTradeHistoryProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(walletTradeHistoryProvider);
    final colors = Theme.of(context).colorScheme;

    if (state.isLoading && state.trades.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.trades.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 36),
              SizedBox(height: 10.h),
              Text(
                state.error!,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              OutlinedButton(
                onPressed: () => ref
                    .read(walletTradeHistoryProvider.notifier)
                    .refresh(widget.accountId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.trades.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref
            .read(walletTradeHistoryProvider.notifier)
            .refresh(widget.accountId),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 100.h),
            const Icon(Icons.history, size: 44),
            SizedBox(height: 12.h),
            const Center(child: Text('No trade history found')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref
          .read(walletTradeHistoryProvider.notifier)
          .refresh(widget.accountId),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
        ),
        itemCount: state.trades.length +
            (state.hasMore || state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          if (index >= state.trades.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: state.isLoadingMore
                    ? const CircularProgressIndicator()
                    : Text(
                  'Scroll to load more',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }

          return _TradeCard(trade: state.trades[index]);
        },
      ),
    );
  }
}





class _TradeCard extends StatelessWidget {
  final WalletTradeModel trade;

  const _TradeCard({required this.trade});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final summary = trade.summary;
    final isProfit = summary.netRealizedPnl >= 0;

    final date = trade.lastOrderAt?.toLocal();
    final dateText = date == null
        ? 'Date unavailable'
        : '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}  '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';

    final accentColor = isProfit
        ? const Color(0xFF36C98F)
        : const Color(0xFFFF646D);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121C2D) : colors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? const Color(0xFF27354A)
              : const Color(0xFFE1E7EF),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          tilePadding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
          childrenPadding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
          trailing: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  trade.symbol,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              _StatusChip(status: trade.status),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  if (trade.orders.isNotEmpty)
                    _InfoChip(
                      label: trade.orders.first.positionSide,
                      isDark: isDark,
                    ),
                  SizedBox(width: 6,),
                  if (trade.orders.isNotEmpty) ...[

                    _InfoChip(
                      label: '${trade.orders.first.leverage}x',
                      isDark: isDark,
                    ),
                  ],

                  Spacer(),
                  Icon(
                    Icons.access_time_rounded,
                    size: 12.sp,
                    color: colors.onSurfaceVariant,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      dateText,
                      maxLines: 1,

                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _Metric(
                        label: 'Realized PnL',
                        value:
                        '${summary.realizedPnl >= 0 ? '+' : ''}'
                            '${summary.realizedPnl.toStringAsFixed(4)}',
                        valueColor: summary.realizedPnl >= 0
                            ? const Color(0xFF36C98F)
                            : const Color(0xFFFF646D),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 34.h,
                      color: colors.outlineVariant,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _Metric(
                        label: 'Net PnL',
                        value:
                        '${isProfit ? '+' : ''}'
                            '${summary.netRealizedPnl.toStringAsFixed(4)}',
                        valueColor: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Divider(color: colors.outlineVariant, height: 22.h),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: 'Filled Quantity',
                    value: summary.filledQuantity.toStringAsFixed(6),
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: 'Avg. Fill Price',
                    value:
                    summary.averageFillPrice?.toStringAsFixed(4) ?? '—',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: 'Total Fees',
                    value: summary.totalFees.toStringAsFixed(4),
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: 'Total Fills',
                    value: '${summary.fillCount}',
                  ),
                ),
              ],
            ),
            if (trade.orders.isNotEmpty) ...[
              SizedBox(height: 20.h),
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 17.sp,
                    color: colors.onSurfaceVariant,
                  ),
                  SizedBox(width: 7.w),
                  Text(
                    'Order Details',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${trade.orders.length} orders',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ...trade.orders.map((order) => _OrderRow(order: order)),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _InfoChip({
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF202D42)
            : const Color(0xFFF0F4F9),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final WalletTradeOrderModel order;

  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isBuy = order.side.toUpperCase() == 'BUY';
    final sideColor = isBuy
        ?  AppColors.green
        :  AppColors.red;

    return Container(
      margin: EdgeInsets.only(bottom: 9.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF192538)
            : const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.withOpacity(0.6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: sideColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  order.side.toUpperCase(),
                  style: TextStyle(
                    color: sideColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  order.orderType,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  order.status.replaceAll('_', ' '),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Price',
                  value: order.averagePrice?.toStringAsFixed(4) ??
                      order.price.toStringAsFixed(4),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Filled / Quantity',
                  value:
                  '${order.filledQuantity.toStringAsFixed(4)} / '
                      '${order.quantity.toStringAsFixed(4)}',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Leverage',
                  value: '${order.leverage}x',
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Order Fee',
                  value: order.fee.toStringAsFixed(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Metric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10.sp,
            color: colors.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: valueColor ?? colors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toUpperCase();

    final Color accent;
    if (normalized == 'FILLED' ||
        normalized == 'CLOSED' ||
        normalized == 'COMPLETED') {
      accent =  AppColors.green;
    } else if (normalized == 'CANCELLED' ||
        normalized == 'REJECTED' ||
        normalized == 'FAILED') {
      accent = AppColors.red;
    } else {
      accent =  Colors.yellow;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(
          color: accent.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
          color: accent,
        ),
      ),
    );
  }
}
