import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/app_strings.dart';
import '../../../core/models/interval_model.dart';
import '../../../providers/interval/custom_intervals_provider.dart';

class CustomIntervalBottomSheet extends ConsumerStatefulWidget {
  const CustomIntervalBottomSheet({super.key});

  @override
  ConsumerState<CustomIntervalBottomSheet> createState() =>
      _CustomIntervalBottomSheetState();
}

class _CustomIntervalBottomSheetState
    extends ConsumerState<CustomIntervalBottomSheet> {

  final TextEditingController controller =
  TextEditingController();

  String selectedType = 'Minutes';
  String? errorText;

  final List<String> types = [
    'Minutes',
    'Hours',
    'Days',
    'Weeks',
    'Months',
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final dark = Theme.of(context).brightness == Brightness.dark;
    final customIntervals = ref.watch(customIntervalsProvider);

    return Padding(
      padding:  EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(

        decoration: BoxDecoration(
          color: dark
              ? AppColors.darkBg
              : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
            
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
              
                  const SizedBox(height: 18),
              
                  Row(
                    children: [
              
                      Expanded(
                        child: Text(
                          'Custom Interval',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: dark
                                ? AppColors.white
                                : AppColors.black,
                          ),
                        ),
                      ),
              
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:  Icon(Icons.close, size: 12, color: dark ? AppColors.white : AppColors.black,),
                      ),
                    ],
                  ),
              

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'You can add custom intervals, up to (${customIntervals.length}/12)',
                      style: TextStyle(
                        fontSize: 13,
                        color: dark
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                  ),
              
                  const SizedBox(height: 24),
              
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 12,
                        color: dark
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                  ),
              
                  const SizedBox(height: 10),
              
                  Container(
                    decoration: BoxDecoration(
                      color: dark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: dark
                            ? AppColors.blue.withOpacity(0.3)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: DropdownMenu<String>(
                      width: double.infinity,
                      initialSelection: selectedType,
                      inputDecorationTheme: const InputDecorationTheme(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      dropdownMenuEntries: types.map((e) {
                        return DropdownMenuEntry(
                          value: e,
                          label: e,
                        );
                      }).toList(),
                      onSelected: (value) {
                        if (value == null) return;
              
                        setState(() {
                          selectedType = value;
                          errorText = null;
                        });
                      },
                    ),
                  ),
              
              
                  const SizedBox(height: 24),
              
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Interval',
                      style: TextStyle(
                        fontSize: 12,
                        color: dark
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                  ),
              
                  const SizedBox(height: 10),
              
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_){
                      if(errorText != null){
                        setState(() {
                          errorText = null;
                        });
                      }
                    },
              
                    decoration: InputDecoration(
                      hintText:
                      'Enter the interval you need',
                      errorText: errorText,
              
                      filled: true,
                      fillColor: dark
                          ? Colors.white10
                          : Colors.grey.shade100,
              
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
              
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: dark ? AppColors.blue : Colors.grey.shade400,
                                  foregroundColor:  dark ? AppColors.white : AppColors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                                 },
                              child: Text(AppStrings.cancel,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700
                                ),
                              ))
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor:  dark ? AppColors.white : AppColors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ),
                            onPressed: () {
                                LogHelper.log("Confirm click");
              
                              setState(() {
                                errorText = null;
                              });
              
                              final value = controller.text.trim();
                              if (value.isEmpty) {
                                return;
                              }
              
                              final number = int.tryParse(value);
              
                              if (number == null ||
                                  number <= 0) {
                                return;
                              }
              
              
                              switch (selectedType) {
              
                                case 'Minutes':
              
                                  if (number > 59) {
                                    setState(() {
                                      errorText =
                                      'Minutes cannot exceed 59';
                                    });
                                    return;
                                  }
              
                                  break;
              
                                case 'Hours':
              
                                  if (number > 23) {
                                    setState(() {
                                      errorText =
                                      'Hours cannot exceed 23';
                                    });
                                    return;
                                  }
              
                                  break;
              
                                case 'Weeks':
              
                                  if (number > 52) {
                                    setState(() {
                                      errorText =
                                      'Weeks cannot exceed 52';
                                    });
                                    return;
                                  }
              
                                  break;
              
                                case 'Months':
              
                                  if (number > 11) {setState(() {
                                    errorText =
                                    'Months cannot exceed 11';
                                  });
                                    return;
                                  }
              
                                  break;
              
                                case 'Days':
                                  break;
                              }
              
              
                              String suffix;
              
                              switch (selectedType) {
              
                                case 'Minutes':
                                  suffix = 'm';
                                  break;
              
                                case 'Hours':
                                  suffix = 'h';
                                  break;
              
                                case 'Days':
                                  suffix = 'd';
                                  break;
              
                                case 'Weeks':
                                  suffix = 'w';
                                  break;
              
                                case 'Months':
                                  suffix = 'M';
                                  break;
              
                                default:
                                  suffix = 'm';
                              }
              
                              final interval = '$number$suffix';
              
                              final model = IntervalModel(
                                label: interval,
                                value: interval,
                                isCustom: true,
                              );
              


                                final added = ref
                                    .read(customIntervalsProvider.notifier)
                                    .addCustom(model);

                                LogHelper.log('Trying to add: $interval');

                                if (!added) {
                                  setState(() {
                                    errorText =
                                    'This interval already exists';
                                  });
                                  return;
                                }


                              Navigator.pop(context);
                            },
                              child: Text(AppStrings.confirm,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700
                                ),
                              ))
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}