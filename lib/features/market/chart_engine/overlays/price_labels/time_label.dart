import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/candle_model.dart';
import '../../providers/crosshair_provider.dart';

class TimeLabel extends ConsumerWidget {
  final List<CandleModel> candles;

  final double chartWidth;

  const TimeLabel({super.key, required this.candles, required this.chartWidth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crosshair = ref.watch(crosshairProvider);

    if (!crosshair.visible || crosshair.candleIndex == null) {
      return const SizedBox();
    }

    final candle = candles[crosshair.candleIndex!];

    final date = candle.time;

    final text =
        "${date.day}-${date.month}-${date.year}  "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";

    const labelWidth = 72.0;

    final labelLeft = (crosshair.position!.dx - (labelWidth / 2)).clamp(
      4.0,
      chartWidth - labelWidth - 4.0,
    );

    return Positioned(
      bottom: 0,

      left: labelLeft,

      child: Container(
        constraints: const BoxConstraints(minHeight: 20, minWidth: labelWidth),

        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),

        decoration: BoxDecoration(
          color: Colors.black,

          borderRadius: BorderRadius.circular(4),

          border: Border.all(color: Colors.white24),
        ),

        alignment: Alignment.center,

        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
