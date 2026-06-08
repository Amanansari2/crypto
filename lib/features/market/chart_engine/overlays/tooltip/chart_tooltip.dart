import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
import 'package:crypto_app/features/market/chart_engine/overlays/tooltip/tooltip_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/models/candle_model.dart';
import '../../providers/crosshair_provider.dart';

class ChartTooltip extends ConsumerWidget {
  final List<CandleModel> candles;

  const ChartTooltip({super.key, required this.candles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crosshair = ref.watch(crosshairProvider);

    if (!crosshair.visible || crosshair.candleIndex == null) {
      return const SizedBox();
    }

    final index = crosshair.candleIndex!;

    if (index < 0 || index >= candles.length) {
      return const SizedBox();
    }

    final candle = candles[index];

    final formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(candle.time);

    final isBull = candle.close >= candle.open;

    final change = candle.close - candle.open;

    final changePercent = candle.open == 0
        ? 0.0
        : ((change / candle.open) * 100);

    final position = crosshair.position!;

    const tooltipWidth = ChartConfig.tooltipWidth;

    const tooltipHeight = ChartConfig.tooltipHeight;

    double left = position.dx + 12;

    // double top = position.dy - tooltipHeight - 12;
    const double top = 8;

    if (left + tooltipWidth > MediaQuery.of(context).size.width) {
      left = position.dx - tooltipWidth - 12;
    }
    //
    // if (top < 8) {
    //   top = position.dy + 12;
    // }

    return Positioned(
      left: left,
      top: 8,

      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.82),

            borderRadius: BorderRadius.circular(8),

            border: Border.all(color: Colors.white10),
          ),

          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,

              fontSize: 10,

              fontWeight: FontWeight.w500,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                TooltipRow(label: "Date ", value: formattedDate),

                TooltipRow(
                  label: "Open ",
                  value: candle.open.toStringAsFixed(2),
                ),

                TooltipRow(
                  label: "High ",
                  value: candle.high.toStringAsFixed(2),
                ),

                TooltipRow(label: "Low ", value: candle.low.toStringAsFixed(2)),

                TooltipRow(
                  label: "Close ",
                  value: candle.close.toStringAsFixed(2),
                  valueColor: isBull ? AppColors.green : AppColors.red,
                ),

                TooltipRow(
                  label: "Chg ",
                  value:
                      "${change >= 0 ? '+' : ''}"
                      "${change.toStringAsFixed(2)} ",
                  valueColor: isBull ? AppColors.green : AppColors.red,
                ),

                TooltipRow(
                  label: "Chg% ",
                  value: "${changePercent.toStringAsFixed(2)}%",
                  valueColor: isBull ? AppColors.green : AppColors.red,
                ),

                TooltipRow(
                  label: "Volume ",
                  value: candle.volume.toStringAsFixed(3),
                  valueColor: isBull ? AppColors.green : AppColors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
