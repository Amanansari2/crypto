import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:crypto_app/features/trade/data/models/position/position_pnl_model.dart';
import 'package:crypto_app/features/trade/ui/widgets/position/partial_close_bottom_sheet.dart';
import 'package:crypto_app/features/trade/ui/widgets/position/tp_sl_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../shared/providers/app_provider.dart';
import '../../../../../shared/services/local_storage_service.dart';
import '../../../data/models/position/position_model.dart';
import '../../../data/providers/position/position_close_provider.dart';
import '../../../data/providers/position/position_pnl_provider.dart';
import '../../../data/providers/position/position_provider.dart';
import '../../../data/providers/trading_account_provider.dart';

class PositionsSection extends ConsumerWidget {
  const PositionsSection({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionNotifier = ref.read(positionProvider.notifier);
    positionNotifier.listenPositionClosed(accountId);
    final state = ref.watch(positionProvider);
    final pnlState = ref.watch(positionPnlProvider(accountId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Positions (${state.positions.length})',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 24),
            Text(
              'Open Orders',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (state.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          )
        else if (state.error != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              state.error!,
              style: const TextStyle(color: Colors.red),
            ),
          )
        else if (state.positions.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('No open positions')),
          )
        else
          Column(
            children: state.positions
                .map(
                  (position) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: PositionCard(
                      position: position,
                      livePnl: pnlState.value?[position.id],
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class PositionCard extends ConsumerWidget {
  const PositionCard({super.key, required this.position, this.livePnl});

  final PositionModel position;
  final PositionPnlModel? livePnl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLong = position.side.toUpperCase() == 'LONG';
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              Text(
                position.symbol,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isLong
                      ? AppColors.green.withValues(alpha: 0.12)
                      : AppColors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isLong ? 'BUY' : 'SELL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isLong ? AppColors.green : AppColors.red,
                  ),
                ),
              ),
              const Spacer(),
              Text(position.marginMode, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              Text(
                '${position.leverage}x',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),

          Divider(),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoItem(
                  label: 'Unrealized PnL',
                  value: (livePnl?.unrealizedPnl ?? position.unrealizedPnl)
                      .toStringAsFixed(4),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: _InfoItem(
                    label: 'Size',
                    value: (position.quantity).toStringAsFixed(4),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _InfoItem(
                    label: 'Margin',
                    value: position.margin.toStringAsFixed(4),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoItem(
                  label: 'Entry Price',
                  value: position.entryPrice.toStringAsFixed(2),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: _InfoItem(
                    label: 'Mark Price',
                    value: (livePnl?.markPrice ?? position.markPrice)
                        .toStringAsFixed(2),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _InfoItem(
                    label: 'Liq. Price',
                    value: position.liquidationPrice == null
                        ? '--'
                        : position.liquidationPrice!.toStringAsFixed(2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _InfoItem(
                    label: 'Take Profit',
                    labelFontSize: 10,
                    valueFontSize: 12,
                    value: position.takeProfit == null
                        ? '--'
                        : position.takeProfit!.toStringAsFixed(2),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _InfoItem(
                    label: 'Stop Loss',
                    labelFontSize: 10,
                    valueFontSize: 12,
                    value: position.stopLoss == null
                        ? '--'
                        : position.stopLoss!.toStringAsFixed(2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.blue.withOpacity(0.08)
                      : AppColors.white,
                  side: BorderSide(
                    color: isDark
                        ? Colors.blue.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.4),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: isDark ? AppColors.white : AppColors.black,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                onPressed: () async {
                  final update = await showModalBottomSheet<bool>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    builder: (_) {
                      return TpSlBottomSheet(position: position);
                    },
                  );
                  if (update == true) {
                    await ref
                        .read(positionProvider.notifier)
                        .getOpenPositions(position.accountId);
                  }
                },
                child: Text('TP/SL'),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.blue.withOpacity(0.08)
                      : AppColors.white,
                  side: BorderSide(
                    color: isDark
                        ? Colors.blue.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.4),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: isDark ? AppColors.white : AppColors.black,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                onPressed: () async {
                  final quantity = await showModalBottomSheet<double>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    builder: (_) {
                      return PartialCloseBottomSheet(position: position);
                    },
                  );

                  if (quantity == null) {
                    return;
                  }

                  final closeSide = position.side.toUpperCase() == 'LONG'
                      ? 'SELL'
                      : 'BUY';

                  await ref
                      .read(positionCloseProvider.notifier)
                      .closePosition(
                        accountId: position.accountId,
                        tradeId: position.tradeId,
                        symbol: position.symbol,
                        side: closeSide,
                        quantity: quantity,
                      );

                  final closeState = ref.read(positionCloseProvider);

                  if (!context.mounted) {
                    return;
                  }

                  if (closeState.error != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(closeState.error!)));
                    return;
                  }

                  await ref
                      .read(tradingAccountProvider.notifier)
                      .getTradingAccount(position.accountId);

                  await ref
                      .read(positionProvider.notifier)
                      .getOpenPositions(position.accountId);


                },
                child: Text('Partial Close'),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.blue.withOpacity(0.08)
                      : AppColors.white,
                  side: BorderSide(
                    color: isDark
                        ? Colors.blue.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.4),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: isDark ? AppColors.white : AppColors.black,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                onPressed: () async {
                  final localStorage = ref.read(localStorageProvider);

                  final skipConfirmation = localStorage
                      .isCloseAllConfirmationSkipped();

                  if (!skipConfirmation) {
                    final confirmed = await _showCloseAllConfirmation(
                      context,
                      position,
                      localStorage,
                    );
                    if (!confirmed) {
                      return;
                    }
                  }
                  final closeSide = position.side.toUpperCase() == 'LONG'
                      ? 'SELL'
                      : 'BUY';

                  await ref
                      .read(positionCloseProvider.notifier)
                      .closePosition(
                        accountId: position.accountId,
                        tradeId: position.tradeId,
                        symbol: position.symbol,
                        side: closeSide,
                        quantity: position.quantity,
                      );

                  final closeState = ref.read(positionCloseProvider);

                  if (!context.mounted) {
                    return;
                  }

                  if (closeState.error != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(closeState.error!)));
                    return;
                  }

                  await ref
                      .read(tradingAccountProvider.notifier)
                      .getTradingAccount(
                      position.accountId
                  );

                  await ref
                      .read(positionProvider.notifier)
                      .getOpenPositions(position.accountId);


                },
                child: Text('Close All'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _showCloseAllConfirmation(
    BuildContext context,
    PositionModel position,
    LocalStorageService localStorage,
  ) async {
    bool neverShowAgain = false;
    final dark = Theme.of(context).brightness == Brightness.dark;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Close Position?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are you sure you want to close the entire '
                    '${position.symbol} ${position.side} position?',
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Checkbox(
                        value: neverShowAgain,
                        onChanged: (value) {
                          setDialogState(() {
                            neverShowAgain = value ?? false;
                          });
                        },
                      ),
                      const Expanded(child: Text('Never show this again')),
                    ],
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: dark ? AppColors.blue : Colors.grey.shade400,
                              foregroundColor:  dark ? AppColors.white : AppColors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),

                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),

                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue,
                            foregroundColor: dark
                                ? AppColors.white
                                : AppColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: () async {
                            if (neverShowAgain) {
                              await localStorage.setCloseAllConfirmationSkipped();
                            }

                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext, true);
                            }
                          },
                          child: const Text('Close All'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    return result ?? false;
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
    this.labelFontSize,
    this.valueFontSize,
  });

  final String label;
  final String value;
  final double? labelFontSize;
  final double? valueFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize ?? 8,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize ?? 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
