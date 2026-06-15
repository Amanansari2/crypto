import 'package:crypto_app/features/market/chart_engine/providers/indicators/kdj/kdj_provider.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_strings.dart';
import '../widget/indicator_checkbox.dart';
import '../widget/indicator_color_box.dart';
import '../widget/indicator_color_picker.dart';

class KdjSettingSheet extends ConsumerStatefulWidget {
  const KdjSettingSheet({super.key});

  @override
  ConsumerState<KdjSettingSheet> createState() => _KdjSettingSheetState();
}

class _KdjSettingSheetState extends ConsumerState<KdjSettingSheet> {
  bool initialized = false;

  int? openedColorPickerIndex;

  late int tempPeriod;

  late int tempMa1;

  late int tempMa2;

  late bool tempShowK;

  late bool tempShowD;

  late bool tempShowJ;

  late Color tempKColor;

  late Color tempDColor;

  late Color tempJColor;

  late TextEditingController periodController;

  late TextEditingController ma1Controller;

  late TextEditingController ma2Controller;

  @override
  void dispose() {
    periodController.dispose();

    ma1Controller.dispose();

    ma2Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(kdjProvider);

    if (!initialized) {
      tempPeriod = settings.period;

      tempMa1 = settings.ma1;

      tempMa2 = settings.ma2;

      tempShowK = settings.showK;

      tempShowD = settings.showD;

      tempShowJ = settings.showJ;

      tempKColor = settings.kColor;

      tempDColor = settings.dColor;

      tempJColor = settings.jColor;

      periodController = TextEditingController(text: tempPeriod.toString());

      ma1Controller = TextEditingController(text: tempMa1.toString());

      ma2Controller = TextEditingController(text: tempMa2.toString());

      initialized = true;
    }

    const kdjColors = [
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
              'KDJ',
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
                    'MA Period 1',
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
                    controller: ma1Controller,
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        tempMa1 = parsed;
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
                    'MA Period 2',
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
                    controller: ma2Controller,
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        tempMa2 = parsed;
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
                        value: tempShowK,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowK = !tempShowK;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'K',
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
                    color: tempKColor,
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
                  colors: kdjColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempKColor = color;

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
                        value: tempShowD,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowD = !tempShowD;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'D',
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
                    color: tempDColor,
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
                  colors: kdjColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempDColor = color;

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
                        value: tempShowJ,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowJ = !tempShowJ;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'J',
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
                    color: tempJColor,
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
                  colors: kdjColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempJColor = color;
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
                      ref.read(kdjProvider.notifier).reset();
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
                      final notifier = ref.read(kdjProvider.notifier);

                      notifier.updatePeriod(tempPeriod);

                      notifier.updateMa1(tempMa1);

                      notifier.updateMa2(tempMa2);

                      notifier.updateKColor(tempKColor);

                      notifier.updateDColor(tempDColor);

                      notifier.updateJColor(tempJColor);

                      if (settings.showK != tempShowK) {
                        notifier.toggleK();
                      }

                      if (settings.showD != tempShowD) {
                        notifier.toggleD();
                      }

                      if (settings.showJ != tempShowJ) {
                        notifier.toggleJ();
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
