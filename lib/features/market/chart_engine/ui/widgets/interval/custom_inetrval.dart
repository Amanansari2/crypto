import 'package:crypto_app/core/utils/constants/app_strings.dart';
import 'package:crypto_app/features/market/chart_engine/providers/interval/custom_interval_edit_provider.dart';
import 'package:crypto_app/features/market/chart_engine/providers/interval/custom_intervals_provider.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/interval/custom_interval_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../core/constants/all_intervals.dart';
import '../../../core/models/interval_model.dart';
import '../../../providers/interval/editing_intervals_provider.dart';
import '../../../providers/interval/intervals_provider.dart';

class CustomIntervalScreen extends ConsumerStatefulWidget {

  const CustomIntervalScreen({super.key,});

  @override
  ConsumerState<CustomIntervalScreen> createState() =>
      _CustomIntervalSheetState();
}

class _CustomIntervalSheetState extends ConsumerState<CustomIntervalScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final confirmed =
      ref.read(intervalsProvider);

      ref
          .read(editingIntervalsProvider.notifier)
          .replaceAll(confirmed);
    });
  }


  bool _dialogShowing = false;


  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    // final selectedIntervals = ref.watch(intervalsProvider);
    final selectedIntervals = ref.watch(editingIntervalsProvider);
    final customInterval = ref.watch(customIntervalsProvider);
    final isEditMode = ref.watch(customIntervalEditProvider);
    final canConfirm = selectedIntervals.length == 5;

    return Scaffold(
      appBar: AppBar(title: Text("Intervals"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${AppStrings.selectInterval} (${selectedIntervals.length}/5)",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color:  dark ? AppColors.white : AppColors.black)
                ),
                IgnorePointer(
                  ignoring: isEditMode,
                  child: Opacity(
                    opacity: isEditMode ? 0.4 : 1,
                    child: TextButton(
                        onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_)=> CustomIntervalBottomSheet());
                        },
                        child: Row(
                          children: [
                            Text(
                              AppStrings.add,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: dark ? AppColors.white : AppColors.black
                              ),
                            ),
                            Icon(Icons.add_box_outlined, size: 12,color:  dark ? AppColors.white : AppColors.black,)
                          ],
                        )),
                  ),
                )
              ],
            ),

            const SizedBox(height: 30,),


            Opacity(
              opacity: isEditMode ? 0.4 : 1,
              child: IgnorePointer(
                ignoring: isEditMode,
                child: _section(
                  title: 'Minute',
                  intervals: AllIntervals.minutes,
                  dark: dark,
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Opacity(
              opacity: isEditMode ? 0.4 : 1,
              child: IgnorePointer(
                ignoring: isEditMode,
                child: _section(
                  title: 'Hour',
                  intervals: AllIntervals.hours,
                  dark: dark,
                ),
              ),
            ),
            const SizedBox(height: 30,),

            Opacity(
              opacity: isEditMode ? 0.4 : 1,
              child: IgnorePointer(
                ignoring: isEditMode,
                child: _section(
                  title: 'Day and above',
                  intervals: AllIntervals.days,
                  dark: dark,
                ),
              ),
            ),

            const SizedBox(height: 30,),


             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                  'Custom Interval',

                  style: TextStyle(
                    color: dark ? AppColors.white : AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                 ),
                 if(customInterval.isNotEmpty)
                   GestureDetector(
                     onTap: (){
                       ref.read(customIntervalEditProvider.notifier).toggle();
                       },
                     child: Row(
                       children: [
                         Text(
                           isEditMode
                               ? 'Save'
                               : 'Delete',
                           style: TextStyle(
                             fontWeight: FontWeight.w600,
                             color: dark
                                 ? AppColors.white
                                 : AppColors.black,
                           ),
                         ),

                         const SizedBox(width: 4),

                         Icon(
                           isEditMode
                               ? Icons.save_outlined
                               : Icons.delete_outline,
                           size: 18,
                         ),
                       ],
                     ),
                   )
               ],
             ),

           customInterval.isEmpty
             ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Tap "Add" in the top right to set custom intervals.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: dark
                          ? Colors.white54
                          : Colors.black54,
                    ),
                  ),
                ),
              )
            :
               _section(title: '', intervals: customInterval, dark: dark, isCustomSection: true),


          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
        child: Row(
          children: [
            Expanded(
                child: Opacity(
                  opacity: isEditMode ? 0.44 : 1,
                  child: IgnorePointer(
                    ignoring: isEditMode,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dark ? AppColors.blue : Colors.grey.shade400,
                        foregroundColor:  dark ? AppColors.white : AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                        onPressed: (){
                        ref.read(editingIntervalsProvider.notifier).resetToDefault();
                        },
                        child: Text(AppStrings.reset,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          ),
                        )),
                  ),
                )
            ),
            const SizedBox(width: 10,),
            Expanded(
                child: IgnorePointer(
                  ignoring: isEditMode,
                  child: Opacity(
                    opacity: (!canConfirm || isEditMode) ? 0.4 : 1,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor:  dark ? AppColors.white : AppColors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            )
                        ),
                        onPressed: (){
                          final editing = ref.read(editingIntervalsProvider);
                          ref.read(intervalsProvider.notifier)
                              .replaceAll(editing);
                          Navigator.pop(context);
                        },
                        child: Text(AppStrings.confirm,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        ),
                        )),
                  ),
                )
            ),
          ],
        ),
      )
    );
  }

  Widget _section({
    required String title,
    required List<IntervalModel> intervals,
    required bool dark,
    bool isCustomSection = false
  }) {
    // final selected = ref.watch(intervalsProvider);
    final selected = ref.watch(editingIntervalsProvider);
    final isEditMode = ref.watch(customIntervalEditProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        GridView.builder(
          shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: intervals.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 12,
              childAspectRatio: 3.3,
            ),
          itemBuilder: (context, index) {
            final interval = intervals[index];

            final isSelected = selected.any((e)=> e.value == interval.value);

                return GestureDetector(
                  onTap: () {
                    if(isEditMode){
                      return;
                    }
                    if(!isSelected &&
                    selected.length>=5){
                      if(_dialogShowing) return;
                      _dialogShowing = true;
                      showDialog(
                        context: context,
                        barrierColor: Colors.black26,
                        barrierDismissible: false,

                        builder: (_) {

                          return Center(

                            child: Material(

                              color: Colors.transparent,

                              child: Container(

                                width: 170,

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),

                                decoration: BoxDecoration(
                                  color: dark
                                      ? AppColors.darkBg
                                      : AppColors.white,

                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                      color: dark
                                          ? AppColors.blue.withOpacity(0.8)
                                          : Colors.grey,
                                      width: 1.4
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:  [
                                    Icon(
                                      Icons.info_outline,
                                      color: dark ? AppColors.white : AppColors.black,
                                      size: 28,
                                    ),

                                    SizedBox(height: 10),

                                    Text(AppStrings.selectIntervalMost,

                                      textAlign: TextAlign.center,

                                      style: TextStyle(
                                        color: dark ? AppColors.white : AppColors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      Future.delayed(
                        const Duration(seconds: 1),
                            () {
                          if(!mounted)return;
                          final navigator = Navigator.of(context, rootNavigator: true);
                          if (navigator.canPop()) {
                            navigator.pop();
                          }
                          _dialogShowing = false;
                        },
                      );
                      return;
                    }
                    ref.read(editingIntervalsProvider.notifier,)
                        .selectInterval(interval,);
                  },

                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Opacity(
                        opacity: (isEditMode && isCustomSection) ? 0.4 : 1,
                        child: Container(
                         alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color: dark
                                ? AppColors.blue.withOpacity(0.08)
                                : AppColors.white,

                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                              : dark
                                  ? AppColors.blue.withOpacity(0.4)
                                  : Colors.grey.withOpacity(0.4),
                              width: isSelected ? 1.4 : 1
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

                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  interval.label,

                                  style: TextStyle(
                                    color: dark ? AppColors.white : AppColors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              if(isSelected)
                                Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      decoration:
                                      const BoxDecoration(

                                        color: Colors.blue,

                                        borderRadius:
                                        BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    )),
                            ],
                          ),
                        ),
                      ),
                      if(isEditMode && isCustomSection)
                        Positioned(
                            top : -5,
                            right: -5,
                            child: GestureDetector(
                              onTap: (){
                                ref.read(customIntervalsProvider.notifier)
                                    .removeCustom(interval.value);

                                ref.read(editingIntervalsProvider.notifier)
                                    .removeInterval(interval.value);
                                final remaining = ref.read(customIntervalsProvider);

                                if(remaining.isEmpty){
                                  ref.read(customIntervalEditProvider.notifier).disable();
                                }
                              },
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                    ],
                  ),
                );

          }
        ),
      ],
    );
  }
}
