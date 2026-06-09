import 'package:crypto_app/core/utils/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../providers/indicators/macd/macd_provider.dart';
import '../widget/indicator_checkbox.dart';
import '../widget/indicator_color_box.dart';
import '../widget/indicator_color_picker.dart';
import '../widget/indicator_textfield.dart';

class MacdSettingsSheet extends ConsumerStatefulWidget {
  const MacdSettingsSheet({super.key});

  @override
  ConsumerState<MacdSettingsSheet> createState() => _MacdSettingsSheetState();
}

class _MacdSettingsSheetState extends ConsumerState<MacdSettingsSheet> {
  bool initialized = false;
  int? openedColorPickerIndex;
  late int tempFastPeriod;
  late int tempSlowPeriod;
  late int tempSignalPeriod;

  late Color tempMacdColor;
  late Color tempSignalColor;

  late bool tempShowMacdLine;
  late bool tempShowSignalLine;

  late TextEditingController fastController;

  late TextEditingController slowController;

  late TextEditingController signalController;

  @override
  void dispose() {
      fastController.dispose();
      slowController.dispose();
      signalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final settings = ref.watch(macdProvider);

    if (!initialized) {
      tempFastPeriod =
          settings.fastPeriod;

      tempSlowPeriod =
          settings.slowPeriod;

      tempSignalPeriod =
          settings.signalPeriod;

      tempMacdColor =
          settings.macdColor;

      tempSignalColor =
          settings.signalColor;

      tempShowMacdLine =
          settings.showMacdLine;

      tempShowSignalLine =
          settings.showSignalLine;

      fastController =
          TextEditingController(
            text:
            tempFastPeriod
                .toString(),
          );

      slowController =
          TextEditingController(
            text:
            tempSlowPeriod
                .toString(),
          );

      signalController =
          TextEditingController(
            text:
            tempSignalPeriod
                .toString(),
          );

      initialized = true;
    }

    const macdColors = [
      Colors.yellow,
      Colors.indigo,
      Colors.blue,
      Colors.green,

      Colors.purple,
      Colors.orange,
      Colors.red,
      Colors.cyan,

      Colors.teal,
      Colors.pink,
      Colors.lime,
      Colors.brown,
    ];

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? AppColors.darkBg : AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Macd',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16,),

            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      'Short Period',
                      style: TextStyle(
                        color: dark
                            ? AppColors.white
                            : AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),),

                Expanded(
                  flex: 1,
                    child: IndicatorTextField(
                      dark: dark,
                      controller: fastController,
                      onChanged: (value) {
                        final parsed =
                        int.tryParse(value);

                        if (parsed != null &&
                            parsed > 0) {
                          tempFastPeriod =
                              parsed;
                        }
                      },
                    ),)
              ],
            ),

            const SizedBox(height: 16,),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Long Period',
                    style: TextStyle(
                      color: dark
                          ? AppColors.white
                          : AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),),

                Expanded(
                  flex: 1,
                  child: IndicatorTextField(
                    dark: dark,
                    controller: slowController,
                    onChanged: (value) {
                      final parsed =
                      int.tryParse(value);

                      if (parsed != null &&
                          parsed > 0) {
                        tempSlowPeriod =
                            parsed;
                      }
                    },
                  ),)
              ],
            ),

            const SizedBox(height: 16,),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Ma Period',
                    style: TextStyle(
                      color: dark
                          ? AppColors.white
                          : AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),),

                Expanded(
                  flex: 1,
                  child: IndicatorTextField(
                    dark: dark,
                    controller: signalController,
                    onChanged: (value) {
                      final parsed =
                      int.tryParse(value);

                      if (parsed != null &&
                          parsed > 0) {
                        tempSignalPeriod =
                            parsed;
                      }
                    },
                  ),
                  )
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: dark ? AppColors.blue.withOpacity(0.8) : Colors.grey.shade400,
              ),
            ),

            const SizedBox(height: 16,),

            Row(
              children: [

                Expanded(
                  flex: 4,
                  child: Row(
                    children: [

                      IndicatorCheckBox(
                        value: tempShowMacdLine,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowMacdLine =
                            !tempShowMacdLine;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'DIF',
                        style: TextStyle(
                          color: dark
                              ? AppColors.white
                              : AppColors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: IndicatorColorBox(
                    dark: dark,
                    color: tempMacdColor,
                    onTap: () {
                      setState(() {
                        openedColorPickerIndex =
                        openedColorPickerIndex == 0
                            ? null
                            : 0;
                      });
                    },
                  ),
                ),
              ],
            ),

            if (openedColorPickerIndex == 0)
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 150,
                ),
                child: IndicatorColorPicker(
                  colors: macdColors,
                  onColorSelected: (color) {

                    setState(() {

                      tempMacdColor = color;

                      openedColorPickerIndex =
                      null;
                    });
                  },
                ),
              ),



            const SizedBox(height: 16,),

            Row(
              children: [

                Expanded(
                  flex: 4,
                  child: Row(
                    children: [

                      IndicatorCheckBox(
                        value: tempShowSignalLine,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowSignalLine =
                            !tempShowSignalLine;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'DEA',
                        style: TextStyle(
                          color: dark
                              ? AppColors.white
                              : AppColors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: IndicatorColorBox(
                    dark: dark,
                    color: tempSignalColor,
                    onTap: () {
                      setState(() {
                        openedColorPickerIndex =
                        openedColorPickerIndex == 1
                            ? null
                            : 1;
                      });
                    },
                  ),
                ),
              ],
            ),

            if (openedColorPickerIndex == 1)
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 150,
                ),
                child: IndicatorColorPicker(
                  colors: macdColors,
                  onColorSelected: (color) {

                    setState(() {

                      tempSignalColor = color;

                      openedColorPickerIndex =
                      null;
                    });
                  },
                ),
              ),

            const SizedBox(height: 30,),



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
                    onPressed: () {
                      ref.read(macdProvider.notifier)
                          .reset();
                      Navigator.pop(context);
                    },
                    child:  Text(AppStrings.reset,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

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

                      final notifier =
                      ref.read(macdProvider.notifier);

                      notifier.updateFastPeriod(
                        tempFastPeriod,
                      );

                      notifier.updateSlowPeriod(
                        tempSlowPeriod,
                      );

                      notifier.updateSignalPeriod(
                        tempSignalPeriod,
                      );

                      notifier.updateMacdColor(
                        tempMacdColor,
                      );

                      notifier.updateSignalColor(
                        tempSignalColor,
                      );

                      if (
                      settings.showMacdLine !=
                          tempShowMacdLine
                      ) {
                        notifier.toggleMacdLine();
                      }

                      if (
                      settings.showSignalLine !=
                          tempShowSignalLine
                      ) {
                        notifier.toggleSignalLine();
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(AppStrings.confirm,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }

}
