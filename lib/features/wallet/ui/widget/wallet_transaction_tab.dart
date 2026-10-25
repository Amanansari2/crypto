
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../data/model/wallet_transaction_model.dart';
import '../../data/provider/wallet_transaction_provider.dart';

class WalletTransactionsTab extends ConsumerStatefulWidget {
  final String accountId;

  const WalletTransactionsTab({
    super.key,
    required this.accountId,
  });

  @override
  ConsumerState<WalletTransactionsTab> createState() =>
      _WalletTransactionsTabState();
}

class _WalletTransactionsTabState
    extends ConsumerState<WalletTransactionsTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(walletTransactionsProvider.notifier)
          .loadTransactions(widget.accountId);
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 150) {
      ref.read(walletTransactionsProvider.notifier).loadMore();
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
    final state = ref.watch(walletTransactionsProvider);
    final colors = Theme.of(context).colorScheme;

    if (state.isLoading && state.transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.transactions.isEmpty) {
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
                    .read(walletTransactionsProvider.notifier)
                    .refresh(widget.accountId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.transactions.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref
            .read(walletTransactionsProvider.notifier)
            .refresh(widget.accountId),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 100.h),
            const Icon(Icons.receipt_long_outlined, size: 42),
            SizedBox(height: 12.h),
            const Center(child: Text('No transactions found')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref
          .read(walletTransactionsProvider.notifier)
          .refresh(widget.accountId),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
        ),
        itemCount: state.transactions.length +
            (state.hasMore || state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          if (index >= state.transactions.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: state.isLoadingMore
                    ? const CircularProgressIndicator()
                    : Text(
                  'Loading more transactions...',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            );
          }

          final transaction = state.transactions[index];

          return _TransactionCard(transaction: transaction);
        },
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final WalletTransactionItemModel transaction;

  const _TransactionCard({
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colors = Theme.of(context).colorScheme;
    final amount = transaction.amount;
    final isPositive = amount > 0;

    final date = transaction.createdAt;
    final dateText = date == null
        ? 'Date unavailable'
        : '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _transactionIcon(transaction.type),
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.type.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${isPositive ? '+' : ''}${amount.toStringAsFixed(2)} USDT',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: isPositive
                      ? colors.primary
                      : colors.error,
                ),
              ),
            ],
          ),
          if (transaction.description.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              transaction.description,
              style: TextStyle(
                fontSize: 12.sp,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Divider(height: 1, color: colors.outlineVariant),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _BalanceInfo(
                  label: 'Balance before',
                  value: transaction.balanceBefore,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _BalanceInfo(
                  label: 'Balance after',
                  value: transaction.balanceAfter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _transactionIcon(String type) {
    switch (type.toUpperCase()) {
      case 'REALIZED_PNL':
        return Icons.trending_up;
      case 'FEE':
        return Icons.receipt_long_outlined;
      case 'MARGIN':
        return Icons.lock_outline;
      case 'MARGIN_RELEASE':
        return Icons.lock_open_outlined;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }
}

class _BalanceInfo extends StatelessWidget {
  final String label;
  final double value;

  const _BalanceInfo({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: colors.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${value.toStringAsFixed(2)} USDT',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
