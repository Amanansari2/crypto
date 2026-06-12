import 'package:crypto_app/features/market/chart_engine/providers/indicators/boll/boll_provider.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_strings.dart';
import '../widget/indicator_checkbox.dart';
import '../widget/indicator_color_box.dart';
import '../widget/indicator_color_picker.dart';

class BollSettingSheet extends ConsumerStatefulWidget {
  const BollSettingSheet({super.key});

  @override
  ConsumerState<BollSettingSheet> createState() => _BollSettingSheetState();
}

class _BollSettingSheetState extends ConsumerState<BollSettingSheet> {
  bool initialized = false;

  int? openedColorPickerIndex;

  late int tempPeriod;

  late double tempBandwidth;

  late Color tempUpperColor;

  late Color tempMiddleColor;

  late Color tempLowerColor;

  late bool tempShowUpper;

  late bool tempShowMiddle;

  late bool tempShowLower;

  late TextEditingController periodController;

  late TextEditingController bandwidthController;

  @override
  void dispose() {
    periodController.dispose();
    bandwidthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(bollProvider);

    if (!initialized) {
      tempPeriod = settings.period;

      tempBandwidth = settings.bandwidth;

      tempUpperColor = settings.upperColor;

      tempMiddleColor = settings.middleColor;

      tempLowerColor = settings.lowerColor;

      tempShowUpper = settings.showUpper;

      tempShowMiddle = settings.showMiddle;

      tempShowLower = settings.showLower;

      periodController = TextEditingController(text: tempPeriod.toString());

      bandwidthController = TextEditingController(
        text: tempBandwidth.toString(),
      );

      initialized = true;
    }
    const bollColors = [
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
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
              'BOLL',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Calculating Period',
                    style: TextStyle(
                      color: dark ? AppColors.white : AppColors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: IndicatorTextField(
                    dark: dark,
                    controller: periodController,
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        tempPeriod = parsed;
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Bandwidth',
                    style: TextStyle(
                      color: dark ? AppColors.white : AppColors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: IndicatorTextField(
                    dark: dark,
                    controller: bandwidthController,
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        tempBandwidth = parsed;
                      }
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: dark
                    ? AppColors.blue.withOpacity(0.8)
                    : Colors.grey.shade400,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Index',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: dark ? AppColors.white : AppColors.black,
                    ),
                  ),

                  Text(
                    'Color',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: dark ? AppColors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      IndicatorCheckBox(
                        value: tempShowUpper,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowUpper = !tempShowUpper;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'UP',
                        style: TextStyle(
                          color: dark ? AppColors.white : AppColors.black,
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
                    color: tempUpperColor,
                    onTap: () {
                      setState(() {
                        openedColorPickerIndex = openedColorPickerIndex == 0
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
                padding: const EdgeInsets.only(top: 8, left: 150),
                child: IndicatorColorPicker(
                  colors: bollColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempUpperColor = color;

                      openedColorPickerIndex = null;
                    });
                  },
                ),
              ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      IndicatorCheckBox(
                        value: tempShowMiddle,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowMiddle = !tempShowMiddle;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'MB',
                        style: TextStyle(
                          color: dark ? AppColors.white : AppColors.black,
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
                    color: tempMiddleColor,
                    onTap: () {
                      setState(() {
                        openedColorPickerIndex = openedColorPickerIndex == 1
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
                padding: const EdgeInsets.only(top: 8, left: 150),
                child: IndicatorColorPicker(
                  colors: bollColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempMiddleColor = color;

                      openedColorPickerIndex = null;
                    });
                  },
                ),
              ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      IndicatorCheckBox(
                        value: tempShowLower,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowLower = !tempShowLower;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'DN',
                        style: TextStyle(
                          color: dark ? AppColors.white : AppColors.black,
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
                    color: tempLowerColor,
                    onTap: () {
                      setState(() {
                        openedColorPickerIndex = openedColorPickerIndex == 2
                            ? null
                            : 2;
                      });
                    },
                  ),
                ),
              ],
            ),

            if (openedColorPickerIndex == 2)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 150),
                child: IndicatorColorPicker(
                  colors: bollColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempLowerColor = color;

                      openedColorPickerIndex = null;
                    });
                  },
                ),
              ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dark
                          ? AppColors.blue
                          : Colors.grey.shade400,
                      foregroundColor: dark ? AppColors.white : AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      ref.read(bollProvider.notifier).reset();
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.reset,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: dark ? AppColors.white : AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final notifier = ref.read(bollProvider.notifier);

                      notifier.updatePeriod(tempPeriod);

                      notifier.updateBandwidth(tempBandwidth);

                      notifier.updateUpperColor(tempUpperColor);

                      notifier.updateMiddleColor(tempMiddleColor);

                      notifier.updateLowerColor(tempLowerColor);

                      if (settings.showUpper != tempShowUpper) {
                        notifier.toggleUpper();
                      }

                      if (settings.showMiddle != tempShowMiddle) {
                        notifier.toggleMiddle();
                      }

                      if (settings.showLower != tempShowLower) {
                        notifier.toggleLower();
                      }

                      Navigator.pop(context);
                    },
                    child: const Text(
                      AppStrings.confirm,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
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
