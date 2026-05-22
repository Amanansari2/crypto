import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
import 'package:flutter/material.dart';

class TooltipRow extends StatelessWidget {
  final String label;

  final String value;

  final Color? valueColor;

  const TooltipRow({
    super.key,

    required this.label,

    required this.value,

    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),

      child: Row(
        children: [
          SizedBox(
            width: ChartConfig.tooltipKeyWidth.toDouble(),

            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),

          SizedBox(
            width: ChartConfig.tooltipValueWidth.toDouble(),

            child: Text(
              value,

              textAlign: TextAlign.right,

              style: TextStyle(color: valueColor ?? Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
