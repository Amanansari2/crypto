
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../data/model/wallet_overview_model.dart';

class WalletOverviewTab extends StatelessWidget {
  final List<WalletTransactionModel> transactions;

  const WalletOverviewTab({
    super.key,
    required this.transactions,
  });

  String _formatAmount(double amount) {
    return '${amount.abs().toStringAsFixed(2)} USDT';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';

    final localDate = date.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final year = localDate.year;
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return '$day/$month/$year  $hour:$minute';
  }

  IconData _transactionIcon(String type) {
    switch (type.toUpperCase()) {
      case 'DEPOSIT':
        return Icons.south_west;
      case 'WITHDRAWAL':
        return Icons.north_east;
      case 'REALIZED_PNL':
        return Icons.trending_up;
      case 'FEE':
        return Icons.receipt_long_outlined;
      case 'MARGIN':
        return Icons.lock_outline;
      case 'MARGIN_RELEASE':
        return Icons.lock_open_outlined;
      case 'FUNDING_FEE':
        return Icons.payments_outlined;
      case 'LIQUIDATION':
        return Icons.warning_amber_rounded;
      default:
        return Icons.swap_horiz;
    }
  }

  String _transactionTitle(String type) {
    switch (type.toUpperCase()) {
      case 'REALIZED_PNL':
        return 'Realized PnL';
      case 'MARGIN_RELEASE':
        return 'Margin Released';
      case 'FUNDING_FEE':
        return 'Funding Fee';
      default:
        final value = type.replaceAll('_', ' ').toLowerCase();
        return value
            .split(' ')
            .map(
              (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
            .join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;


    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 42.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 10.h),
            Text(
              'No recent transactions',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }


    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isPositive = transaction.amount > 0;

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
                      size: 21.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _transactionTitle(transaction.type),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _formatDate(transaction.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${isPositive ? '+' : '-'}${_formatAmount(transaction.amount)}',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isPositive ? Colors.green : colorScheme.error,
                    ),
                  ),
                ],
              ),
              if (transaction.description.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Divider(
                  height: 1,
                  color: colorScheme.outlineVariant,
                ),
                SizedBox(height: 10.h),
                Text(
                  transaction.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );

  }
}
