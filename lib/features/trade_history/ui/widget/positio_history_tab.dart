import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../data/model/position_history_model.dart';
import '../../data/provider/position_history_provider.dart';

class PositionHistoryTab extends ConsumerStatefulWidget {
  final String accountId;

  const PositionHistoryTab({super.key, required this.accountId});

  @override
  ConsumerState<PositionHistoryTab> createState() => _PositionHistoryTabState();
}

class _PositionHistoryTabState extends ConsumerState<PositionHistoryTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref
          .read(positionHistoryProvider.notifier)
          .getPositionHistory(widget.accountId);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(positionHistoryProvider.notifier)
          .getPositionHistory(widget.accountId);
    }
  }

  Future<void> _refresh() async {
    await ref.read(positionHistoryProvider.notifier).refresh(widget.accountId);
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

    final state = ref.watch(positionHistoryProvider);

    if (state.isLoading && state.positions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.positions.isEmpty) {
      return _PositionMessageView(
        message: state.error!,
        icon: Icons.cloud_off_outlined,
        actionLabel: 'Retry',
        onAction: () {
          ref
              .read(positionHistoryProvider.notifier)
              .getPositionHistory(widget.accountId, refresh: true);
        },
      );
    }

    if (state.positions.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 180),
            Icon(Icons.history, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Center(child: Text('No position history found')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        key: const PageStorageKey('position_history_list'),
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount:
            state.positions.length +
            (state.isLoadingMore || state.error != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.positions.length) {
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    ref
                        .read(positionHistoryProvider.notifier)
                        .getPositionHistory(widget.accountId);
                  },
                  child: const Text('Retry loading more'),
                ),
              ),
            );
          }

          final position = state.positions[index];

          return _PositionHistoryCard(position: position);
        },
      ),
    );
  }
}

class _PositionHistoryCard extends StatelessWidget {
  final PositionHistoryModel position;

  const _PositionHistoryCard({required this.position});

  String _number(double? value, {int decimals = 2}) {
    return value == null ? '—' : value.toStringAsFixed(decimals);
  }

  String _date(DateTime? value) {
    if (value == null) return '—';

    final d = value.toLocal();

    final date =
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';

    final time =
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';

    return '$date  $time';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isLong = position.side.toUpperCase() == 'LONG';

    final pnl = position.realizedPnl;
    final pnlColor = pnl == null
        ? Theme.of(context).colorScheme.onSurface
        : pnl > 0
        ? AppColors.green
        : pnl < 0
        ? AppColors.red
        : Theme.of(context).colorScheme.onSurface;

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
          // Symbol, position side and status.
          Row(
            children: [
              Text(
                position.symbol,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: (isLong ? AppColors.green : AppColors.red).withOpacity(
                    0.12,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  position.side.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isLong ? AppColors.green : AppColors.red,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                position.status,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: position.status.toUpperCase() == 'CLOSED'
                      ? Colors.grey
                      : AppColors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Divider(),

          // Entry price, exit price and quantity.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PositionInfoRow(
                label: 'Entry Price',
                value: _number(position.entryPrice),
              ),
              _PositionInfoRow(
                label: 'Exit Price',
                value: _number(position.exitPrice),
              ),
              _PositionInfoRow(
                label: 'Quantity',
                value: _number(position.quantity, decimals: 5),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Leverage, margin and realized PnL.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PositionInfoRow(
                label: 'Leverage',
                value: '${position.leverage}x',
              ),
              _PositionInfoRow(
                label: 'Margin',
                value: _number(position.margin),
              ),
              _PositionInfoRow(
                label: 'Realized PnL',
                value: _number(pnl, decimals: 5),
                valueColor: pnlColor,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Created and closed timestamps.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PositionInfoRow(
                label: 'Created At',
                value: _date(position.createdAt),
                fontSizeLabel: 10,
                fontSizeText: 8,
              ),
              _PositionInfoRow(
                label: 'Closed At',
                value: _date(position.closedAt),
                fontSizeLabel: 10,
                fontSizeText: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final double? fontSizeLabel;
  final double? fontSizeText;
  final Color? valueColor;

  const _PositionInfoRow({
    required this.label,
    required this.value,
    this.fontSizeLabel,
    this.fontSizeText,
    this.valueColor,
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
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: fontSizeText ?? 12,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _PositionMessageView extends StatelessWidget {
  final String message;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onAction;

  const _PositionMessageView({
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
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
