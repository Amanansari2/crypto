import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../data/model/order_history_model.dart';
import '../../data/provider/order_history_provider.dart';

class OrderHistoryTab extends ConsumerStatefulWidget {
  final String accountId;

  const OrderHistoryTab({
    super.key,
    required this.accountId,
  });

  @override
  ConsumerState<OrderHistoryTab> createState() =>
      _OrderHistoryTabState();
}

class _OrderHistoryTabState extends ConsumerState<OrderHistoryTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref
          .read(orderHistoryProvider.notifier)
          .getOrderHistory(widget.accountId);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(orderHistoryProvider.notifier)
          .getOrderHistory(widget.accountId);
    }
  }

  Future<void> _refresh() async {
    await ref
        .read(orderHistoryProvider.notifier)
        .refresh(widget.accountId);
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
    super.build(context);

    final state = ref.watch(orderHistoryProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (state.isLoading && state.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.orders.isEmpty) {
      return _MessageView(
        message: state.error!,
        icon: Icons.cloud_off_outlined,
        actionLabel: 'Retry',
        onAction: () {
          ref
              .read(orderHistoryProvider.notifier)
              .getOrderHistory(widget.accountId, refresh: true);
        },
      );
    }

    if (state.orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 180),
            Icon(Icons.receipt_long_outlined,
                size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Center(child: Text('No order history found')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        key: const PageStorageKey('order_history_list'),
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: state.orders.length +
            (state.isLoadingMore || state.error != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.orders.length) {
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    ref
                        .read(orderHistoryProvider.notifier)
                        .getOrderHistory(widget.accountId);
                  },
                  child: const Text('Retry loading more'),
                ),
              ),
            );
          }

          final order = state.orders[index];

          return _OrderHistoryCard(
            order: order,
          );
        },
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  final OrderHistoryModel order;

  const _OrderHistoryCard({
    required this.order,
  });

  String _number(double? value) =>
      value == null ? '—-' : value.toStringAsFixed(2);

  String _date(DateTime? value) {
    if (value == null) return '—';

    final d = value.toLocal();
    final date = '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
    final time = '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';

    return '$date  $time';
  }

  @override
  Widget build(BuildContext context) {
    final isBuy = order.side.toUpperCase() == 'BUY';

    final isDark = Theme.of(context).brightness== Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: isDark ? AppColors.blue.withOpacity(0.08) : AppColors.white,

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
        children: [
          Row(
            children: [
              Text(
                order.symbol,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isBuy
                      ? AppColors.green.withValues(alpha: 0.12)
                      : AppColors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.side.toUpperCase(),
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color:  isBuy ? AppColors.green : AppColors.red
                  ),
                ),
              ),

              Spacer(),

              Text(
                order.status,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: order.status.toUpperCase() == 'FILLED'
                        ? AppColors.green
                        : order.status.toUpperCase() == 'CANCELLED'
                        ? AppColors.red
                        : Colors.orange,
                    fontSize: 12,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),

          Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoRow(
                label: 'Order Type',
                value: order.orderType,

              ),
              _InfoRow(
                  label: 'Price',
                  value: _number(order.price),
              ),
              _InfoRow(
                label: 'Quantity',
                value: order.quantity.toStringAsFixed(5),

              ),
            ],
          ),

          const SizedBox(height: 6,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoRow(
                label: 'Take Profit',
                value: _number(order.takeProfit),
              ),

              _InfoRow(
                label: 'Fee',
                value: order.fee.toStringAsFixed(5) ,
              ),


              _InfoRow(
                label: 'Stop Loss',
                value: _number(order.stopLoss),
              ),
            ],
          ),

          const SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              _InfoRow(
                label: 'Created at',
                value: _date(order.createdAt),
                fontSizeLabel: 10,
                fontSizeText: 8,
              ),
              _InfoRow(
                label: 'Updated at',
                value: _date(order.updatedAt),
                fontSizeLabel: 10,
                fontSizeText: 8,
              ),
            ],
          )

        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final double? fontSizeLabel;
  final double? fontSizeText;


  const _InfoRow({
    required this.label,
    required this.value,
    this.fontSizeLabel,
    this.fontSizeText
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSizeLabel ?? 10,
            fontWeight: FontWeight.w600
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: fontSizeText ?? 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _MessageView extends StatelessWidget {
  final String message;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onAction;

  const _MessageView({
    required this.message,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
