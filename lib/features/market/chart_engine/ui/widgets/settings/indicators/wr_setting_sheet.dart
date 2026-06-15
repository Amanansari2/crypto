import 'package:crypto_app/features/market/chart_engine/providers/indicators/wr/wr_provider.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_color_box.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_color_picker.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_strings.dart';

class WrSettingSheet extends ConsumerStatefulWidget {
  const WrSettingSheet({super.key});

  @override
  ConsumerState<WrSettingSheet> createState() => _WrSettingSheetState();
}

class _WrSettingSheetState extends ConsumerState<WrSettingSheet> {
  bool initialized = false;
  int? openedColorPickerIndex;

  late int tempPeriod;

  late Color tempColor;

  late TextEditingController periodController;

  @override
  void dispose() {
    periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(wrProvider);

    if (!initialized) {
      tempPeriod = settings.period;

      tempColor = settings.color;

      periodController = TextEditingController(text: tempPeriod.toString());

      initialized = true;
    }

    const wrColors = [
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
              'WR',
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
                  child: Text(
                    'WR',
                    style: TextStyle(
                      color: dark ? AppColors.white : AppColors.black,
                      fontSize: 14,
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
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

                const SizedBox(width: 20),

                Expanded(
                  flex: 1,
                  child: IndicatorColorBox(
                    dark: dark,
                    color: tempColor,
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
                  colors: wrColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempColor = color;
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
                      ref.read(wrProvider.notifier).reset();

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
                      ref.read(wrProvider.notifier).updatePeriod(tempPeriod);

                      ref.read(wrProvider.notifier).updateColor(tempColor);

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
