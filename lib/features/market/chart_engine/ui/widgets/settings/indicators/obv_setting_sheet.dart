import 'package:crypto_app/features/market/chart_engine/providers/indicators/obv/obv_data_provider.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_checkbox.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_color_box.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_color_picker.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_strings.dart';
import '../../../../providers/indicators/obv/obv_provider.dart';
import '../../../../providers/indicators/roc/roc_provider.dart';

class ObvSettingSheet extends ConsumerStatefulWidget {
  const ObvSettingSheet({super.key});

  @override
  ConsumerState<ObvSettingSheet> createState() => _ObvSettingSheetState();
}

class _ObvSettingSheetState extends ConsumerState<ObvSettingSheet> {

  bool initialized = false;

  int? openedColorPickerIndex;

  late int tempMaPeriod;

  late bool tempShowObv;

  late bool tempShowMaObv;

  late Color tempObvColor;

  late Color tempMaObvColor;

  late TextEditingController maController;

  @override
  void dispose() {
    maController.dispose();
    maController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(obvProvider);

    if (!initialized) {

      tempMaPeriod =
          settings.maPeriod;

      tempShowObv =
          settings.showObv;

      tempShowMaObv =
          settings.showMaObv;

      tempObvColor =
          settings.obvColor;

      tempMaObvColor =
          settings.maObvColor;

      maController =
          TextEditingController(
            text: tempMaPeriod.toString(),
          );

      initialized = true;
    }

    const obvColors = [

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
              'OBV',
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
                  flex: 5,
                  child: Row(
                    children: [
                      IndicatorCheckBox(
                        value: tempShowObv,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowObv = !tempShowObv;
                          });
                        },
                      ),

                      const SizedBox(width: 10),
                      Text(
                        'OBV',
                        style: TextStyle(
                          color: dark ? AppColors.white : AppColors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(width: 20),

                Expanded(
                  flex: 1,
                  child: IndicatorColorBox(
                    dark: dark,
                    color: tempObvColor,
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
                  colors: obvColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempObvColor = color;
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
                        value: tempShowMaObv,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowMaObv = !tempShowMaObv;
                          });
                        },
                      ),

                      const SizedBox(width: 10),
                      Text(
                        'MAOBV',
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
                    color: tempMaObvColor,
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
                  colors: obvColors,
                  onColorSelected: (color) {
                    setState(() {
                      tempMaObvColor = color;
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
                      ref.read(obvProvider.notifier).reset();
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

                      final notifier =
                      ref.read(
                        obvProvider.notifier,
                      );

                      notifier.updateMaPeriod(
                        tempMaPeriod,
                      );

                      notifier.updateObvColor(
                        tempObvColor,
                      );

                      notifier.updateMaObvColor(
                        tempMaObvColor,
                      );

                      if (
                      settings.showObv !=
                          tempShowObv
                      ) {

                        notifier.toggleObv();
                      }

                      if (
                      settings.showMaObv !=
                          tempShowMaObv
                      ) {

                        notifier.toggleMaObv();
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
