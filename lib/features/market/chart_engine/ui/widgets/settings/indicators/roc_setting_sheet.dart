import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_checkbox.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_color_box.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_color_picker.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_strings.dart';
import '../../../../providers/indicators/roc/roc_provider.dart';

class RocSettingSheet extends ConsumerStatefulWidget {
  const RocSettingSheet({super.key});

  @override
  ConsumerState<RocSettingSheet> createState() => _RocSettingSheetState();
}

class _RocSettingSheetState extends ConsumerState<RocSettingSheet> {
  bool initialized = false;

  int? openedColorPickerIndex;

  late int tempRocPeriod;

  late int tempMaPeriod;

  late bool tempShowRoc;

  late bool tempShowMaRoc;

  late Color tempRocColor;

  late Color tempMaRocColor;

  late TextEditingController rocController;

  late TextEditingController maController;

  @override
  void dispose() {
    rocController.dispose();
    maController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(rocProvider);

    if (!initialized) {
      tempRocPeriod = settings.rocPeriod;

      tempMaPeriod = settings.maPeriod;

      tempShowRoc = settings.showRoc;

      tempShowMaRoc = settings.showMaRoc;

      tempRocColor = settings.rocColor;

      tempMaRocColor = settings.maRocColor;

      rocController = TextEditingController(text: tempRocPeriod.toString());

      maController = TextEditingController(text: tempMaPeriod.toString());

      initialized = true;
    }

    const rocColors = [
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
              'ROC',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Index',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: dark ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Text(
                    'Value',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: dark ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Text(
                    'Color',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: dark ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      IndicatorCheckBox(
                        value: tempShowRoc,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowRoc = !tempShowRoc;
                          });
                        },
                      ),

                      const SizedBox(width: 10),
                      Text(
                        'ROC',
                        style: TextStyle(
                          color: dark ? AppColors.white : AppColors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: IndicatorTextField(
                    dark: dark,
                    controller: rocController,
                    onChanged: (value) {
                      final parsed = int.tryParse(value);

                      if (parsed != null && parsed > 0) {
                        tempRocPeriod = parsed;
                      }
                    },
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  flex: 1,
                  child: IndicatorColorBox(
                    dark: dark,
                    color: tempRocColor,
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
                  colors: rocColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempRocColor = color;
                      openedColorPickerIndex = null;
                    });
                  },
                ),
              ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      IndicatorCheckBox(
                        value: tempShowMaRoc,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowMaRoc = !tempShowMaRoc;
                          });
                        },
                      ),

                      const SizedBox(width: 10),
                      Text(
                        'MAROC',
                        style: TextStyle(
                          color: dark ? AppColors.white : AppColors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IndicatorTextField(
                    dark: dark,
                    controller: maController,
                    onChanged: (value) {
                      final parsed = int.tryParse(value);

                      if (parsed != null && parsed > 0) {
                        tempMaPeriod = parsed;
                      }
                    },
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  flex: 1,
                  child: IndicatorColorBox(
                    dark: dark,
                    color: tempMaRocColor,
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
                  colors: rocColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempMaRocColor = color;
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
                      ref.read(rocProvider.notifier).reset();
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
                      final notifier = ref.read(rocProvider.notifier);

                      notifier.updateRocPeriod(tempRocPeriod);

                      notifier.updateMaPeriod(tempMaPeriod);

                      notifier.updateRocColor(tempRocColor);

                      notifier.updateMaRocColor(tempMaRocColor);

                      if (settings.showRoc != tempShowRoc) {
                        notifier.toggleRoc();
                      }

                      if (settings.showMaRoc != tempShowMaRoc) {
                        notifier.toggleMaRoc();
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
