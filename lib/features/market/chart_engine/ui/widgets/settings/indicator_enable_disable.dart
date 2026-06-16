import 'package:crypto_app/features/market/chart_engine/core/models/indicators/indicator_type.dart';
import 'package:crypto_app/features/market/chart_engine/providers/indicators/active_indicators_provider.dart';
import 'package:crypto_app/features/market/chart_engine/providers/indicators/overlay_indicator_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constants/app_colors.dart';

class IndicatorEnableDisable extends ConsumerStatefulWidget {
  const IndicatorEnableDisable({super.key});

  @override
  ConsumerState<IndicatorEnableDisable> createState() =>
      _IndicatorEnableDisableState();
}

class _IndicatorEnableDisableState
    extends ConsumerState<IndicatorEnableDisable> {
  @override
  Widget build(BuildContext context) {

     return SizedBox(
      height: 34.h,

      child: ListView(
        scrollDirection: Axis.horizontal,

        padding: EdgeInsets.symmetric(horizontal: 8.w),

        children: [
          _indicatorButton("MA", IndicatorType.ma),

          _indicatorButton("EMA", IndicatorType.ema),

          _indicatorButton("BOLL", IndicatorType.boll),

          Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            "|",
            style: TextStyle(
              fontSize: 22,
              color: Colors.grey,
            ),
          ),
          ),

          _indicatorButton("VOL", IndicatorType.vol),

          _indicatorButton("MACD", IndicatorType.macd),

          _indicatorButton("KDJ", IndicatorType.kdj),

          _indicatorButton("RSI", IndicatorType.rsi),

          _indicatorButton("ROC", IndicatorType.roc),

          _indicatorButton("WR", IndicatorType.wr),

          _indicatorButton("OBV", IndicatorType.obv),

          _indicatorButton("StochRSI", IndicatorType.stoch),
        ],
      ),
    );
  }

  Widget _indicatorButton(String text, IndicatorType type) {
    final isOverlay =
        type == IndicatorType.ma ||
        type == IndicatorType.ema ||
        type == IndicatorType.boll;

    final overlayIndicator = ref.watch(overlayIndicatorProvider);

    final activeIndicators = ref.watch(activeIndicatorsProvider);

    final selected = isOverlay
        ? overlayIndicator == type
        : activeIndicators.contains(type);

    return GestureDetector(
      onTap: () {
        if (isOverlay) {
          ref.read(overlayIndicatorProvider.notifier).toggle(type);
        } else {
          ref.read(activeIndicatorsProvider.notifier).toggle(type);
        }
      },

      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.w),

        alignment: Alignment.center,

        child: Text(
          text,

          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,

            color:
            selected ? Colors.blue : Colors.grey

          ),
        ),
      ),
    );
  }
}
