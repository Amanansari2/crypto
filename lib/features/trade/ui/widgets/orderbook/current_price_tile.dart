import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/providers/home_ticker_provider.dart';

class CurrentPriceTile extends ConsumerWidget {
  final String symbol;
  const CurrentPriceTile({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homeTickerProvider(symbol),);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: provider.when(
          data: (ticker){
           return Column(
             children: [
               Container(
                 padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                 decoration: BoxDecoration(
                   color: AppColors.red,
                   borderRadius: BorderRadius.circular(4)
                 ),
                 child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(
                           "Best Ask : ",
                           style: TextStyle(
                               fontSize: 10.sp,
                               fontWeight: FontWeight.w500,
                               color: dark ? AppColors.white : AppColors.black
                           ),
                         ),
                         Text(
                           _formatPrice(ticker.ask),
                           style: TextStyle(
                               fontSize: 10.sp,
                               fontWeight: FontWeight.bold,
                               color: dark ? AppColors.white : AppColors.black
                           ),
                         ),
                       ],
                     ),

                     SizedBox(height: 2,),

                     Text(
                       "Highest buy offer",
                       style: TextStyle(
                           fontSize: 10.sp,
                           fontWeight: FontWeight.bold,
                           color: dark ? AppColors.white : AppColors.black
                       ),
                     ),
                   ],
                 ),
               ),

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                     "Last Price : ",
                     style: TextStyle(
                         fontSize: 10.sp,
                         fontWeight: FontWeight.w500,
                         color: dark ? AppColors.white : AppColors.black
                     ),
                   ),
                   Text(
                       _formatPrice(ticker.lastPrice),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: dark ? AppColors.white : AppColors.black
                      ),
                    ),
                 ],
               ),

               Container(
                 padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                 decoration: BoxDecoration(
                     color: AppColors.green,
                     borderRadius: BorderRadius.circular(4)
                 ),
                 child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(
                           "Best Bid : ",
                           style: TextStyle(
                               fontSize: 10.sp,
                               fontWeight: FontWeight.w500,
                               color: dark ? AppColors.white : AppColors.black
                           ),
                         ),
                         Text(
                           _formatPrice(ticker.bid),
                           style: TextStyle(
                               fontSize: 10.sp,
                               fontWeight: FontWeight.bold,
                               color: dark ? AppColors.white : AppColors.black
                           ),
                         ),
                       ],
                     ),
                     SizedBox(height: 2,),

                     Text(
                       "Lowest sell offer",
                       style: TextStyle(
                           fontSize: 10.sp,
                           fontWeight: FontWeight.bold,
                           color: dark ? AppColors.white : AppColors.black
                       ),
                     ),

                   ],
                 ),
               ),


             ],
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