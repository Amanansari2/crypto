import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
import 'package:crypto_app/features/market/chart_engine/overlays/indicators/kdj/kdj_widget.dart';
import 'package:crypto_app/features/market/chart_engine/overlays/indicators/rsi/rsi_widget.dart';
import 'package:crypto_app/features/market/chart_engine/overlays/indicators/volume/volume_widget.dart';
import 'package:crypto_app/features/market/chart_engine/overlays/indicators/wr/wr_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/indicators/indicator_type.dart';
import '../../providers/indicators/active_indicators_provider.dart';
import 'macd/macd_widget.dart';

class IndicatorHost extends ConsumerWidget {
  const IndicatorHost({
    super.key,
  });

  static const double panelHeight = ChartConfig.chartPanelHeight;

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final indicators =
    ref.watch(activeIndicatorsProvider);

    if (indicators.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: indicators.map((type) {

        switch (type) {

          case IndicatorType.vol:
            return Container(
              height: panelHeight,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                ),
              ),
              child: const VolumeWidget(),
            );


            case IndicatorType.rsi:
            return Container(
              height: panelHeight,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                ),
              ),
              child: const RsiWidget(),
            );



          case IndicatorType.macd:
            return Container(
              height: panelHeight,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                ),
              ),
              child: const MacdWidget(),
            );

          case IndicatorType.kdj:
            return Container(
              height: panelHeight,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                ),
              ),
              child: const KdjWidget(),
            );

          case IndicatorType.wr:
            return Container(
              height: panelHeight,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.25),
                  ),
                ),
              ),
              child: const WrWidget(),
            );

          case IndicatorType.obv:
            return const SizedBox(
              height: panelHeight,
              child: Center(
                child: Text('OBV'),
              ),
            );

          case IndicatorType.roc:
            return const SizedBox(
              height: panelHeight,
              child: Center(
                child: Text('ROC'),
              ),
            );

          case IndicatorType.ma:
          case IndicatorType.ema:
          case IndicatorType.boll:
            return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}