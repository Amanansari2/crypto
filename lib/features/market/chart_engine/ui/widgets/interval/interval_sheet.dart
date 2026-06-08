import 'package:crypto_app/app/router/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../providers/candle_provider.dart';
import '../../../core/constants/all_intervals.dart';
import '../../../providers/interval/intervals_provider.dart';
import '../../../providers/interval/selected_interval_provider.dart';


class IntervalSheet
    extends ConsumerWidget {


  const IntervalSheet({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final selected =
    ref.watch(selectedIntervalProvider,);

    final dark = Theme.of(context).brightness == Brightness.dark;


    return Container(

      padding:
      const EdgeInsets.all(16),

      decoration:
      BoxDecoration(
        color: dark? AppColors.darkBg : AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            18,
          ),
        ),
      ),

      child: SingleChildScrollView(

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(

              'Intervals',

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12,),

            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AllIntervals.intervals.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3.3,
                ),
              itemBuilder: (context, index) {

                final interval =
                AllIntervals.intervals[index];
                    return GestureDetector(

                      onTap: () {

                        ref.read(selectedIntervalProvider.notifier,).change(interval,);

                        ref.read(intervalsProvider.notifier,).selectInterval(interval,);

                        ref.read(candleProvider.notifier,).changeInterval(interval.value,);

                        Navigator.pop(context,);
                      },

                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: dark
                              ? AppColors.blue.withOpacity(0.08)
                              : AppColors.white,

                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: dark
                                ? AppColors.blue.withOpacity(0.4)
                                : Colors.grey.withOpacity(0.4),
                          ),
                          boxShadow: dark
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


                        child: Text(

                          interval.label,

                          style: TextStyle(
                            color: dark ? AppColors.white : AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );

              }
            ),






            const SizedBox(
              height: 22,
            ),

            /// 🔥 CUSTOM BUTTON
            GestureDetector(

              onTap: () {

                 Navigator.pop(context);

                context.pushNamed(
                  RouteNames.customIntervalName,

                );
              },

              child: Container(

                width: double.infinity,

                padding:
                const EdgeInsets.symmetric(
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: dark
                      ? AppColors.blue.withOpacity(0.08)
                      : AppColors.white,

                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: dark
                        ? AppColors.blue.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.4),
                  ),
                  boxShadow: dark
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


                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Custom Intervals ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}