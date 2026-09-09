import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TradeButtons extends StatelessWidget {
  final VoidCallback? onBuy;
  final VoidCallback? onSell;

  const TradeButtons({
    super.key,
    this.onBuy,
    this.onSell,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TradeButton(
          label: 'Demo Buy (Long)',
          color: AppColors.green,
          onTap: onBuy,
        ),
        const SizedBox(height: 10),
        _TradeButton(
          label: 'Demo Sell (Short)',
          color: AppColors.red,
          onTap: onSell,
        ),
      ],
    );
  }
}

class _TradeButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _TradeButton({
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
