import 'package:crypto_app/features/market/data/models/binance/binance_ticker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/helpers/formatters.dart';

class PriceSection extends StatelessWidget {
  final BinanceTickerModel ticker;

  const PriceSection({super.key, required this.ticker});

  @override
  Widget build(BuildContext context) {
    final isUp = ticker.priceChangePercent >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FormatHelper.price(ticker.lastPrice),
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
            color: isUp ? AppColors.green : AppColors.red,
          ),
        ),

        SizedBox(height: 3.h),

        Row(
          children: [
            Text(
              "≈ \$${FormatHelper.price(ticker.lastPrice)}",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
            SizedBox(width: 10.w),
            Text(
              FormatHelper.percent(ticker.priceChangePercent),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isUp ? AppColors.green : AppColors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
