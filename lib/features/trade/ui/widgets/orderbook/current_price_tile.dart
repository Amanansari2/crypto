import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/providers/home_ticker_provider.dart';

class CurrentPriceTile extends ConsumerWidget {
  const CurrentPriceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homeTickerProvider("BTCUSDT"),);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: provider.when(
          data: (ticker){
           return Text(
               _formatPrice(ticker.lastPrice),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: dark ? AppColors.white : AppColors.black
              ),
            );

          },

          error: (_, _){
            return Text(
              '--',
              style: TextStyle(
                color: dark ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w300,
                fontSize: 14.sp,
              ),
            );
          },
          loading: (){
            return CircularProgressIndicator(
              color: dark ? AppColors.white : AppColors.black,
            );
          })
    );
  }
  String _formatPrice(double price) {
    return price.toStringAsFixed(2);
  }
}