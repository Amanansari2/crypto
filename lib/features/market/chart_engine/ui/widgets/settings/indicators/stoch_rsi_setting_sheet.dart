import 'package:crypto_app/core/utils/constants/app_strings.dart';
import 'package:crypto_app/features/market/chart_engine/providers/indicators/stoch/stoch_rsi_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../providers/indicators/macd/macd_provider.dart';
import '../widget/indicator_checkbox.dart';
import '../widget/indicator_color_box.dart';
import '../widget/indicator_color_picker.dart';
import '../widget/indicator_textfield.dart';

class StochRsiSettingsSheet extends ConsumerStatefulWidget {
  const StochRsiSettingsSheet({super.key});

  @override
  ConsumerState<StochRsiSettingsSheet> createState() => _StochRsiSettingsSheetState();
}

class _StochRsiSettingsSheetState extends ConsumerState<StochRsiSettingsSheet> {

  bool initialized = false;
  int? openedColorPickerIndex;
  late int tempRsiLength;

  late int tempStochLength;

  late int tempSmoothK;

  late int tempSmoothD;

  late bool tempShowK;

  late bool tempShowD;

  late Color tempKColor;

  late Color tempDColor;

  late TextEditingController rsiController;

  late TextEditingController stochController;

  late TextEditingController smoothKController;
  late TextEditingController smoothDController;

  @override
  void dispose() {
    rsiController.dispose();
    stochController.dispose();
    smoothKController.dispose();
    smoothDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final settings = ref.watch(stochRsiProvider);

    if (!initialized) {

      tempRsiLength =
          settings.rsiLength;

      tempStochLength =
          settings.stochLength;

      tempSmoothK =
          settings.smoothK;

      tempSmoothD =
          settings.smoothD;

      tempShowK =
          settings.showK;

      tempShowD =
          settings.showD;

      tempKColor =
          settings.kColor;

      tempDColor =
          settings.dColor;

      rsiController =
          TextEditingController(
            text:
            tempRsiLength.toString(),
          );

      stochController =
          TextEditingController(
            text:
            tempStochLength.toString(),
          );

      smoothKController =
          TextEditingController(
            text:
            tempSmoothK.toString(),
          );

      smoothDController =
          TextEditingController(
            text:
            tempSmoothD.toString(),
          );

      initialized = true;
    }

    const stochColors = [
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
              'StochRsi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16,),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Length RSI',
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
                    controller: rsiController,
                    onChanged: (value) {
                      final parsed =
                      int.tryParse(value);

                      if (parsed != null &&
                          parsed > 0) {
                        tempRsiLength =
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
                    'Length Stoch',
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
                    controller: stochController,
                    onChanged: (value) {
                      final parsed =
                      int.tryParse(value);

                      if (parsed != null &&
                          parsed > 0) {
                        tempStochLength =
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
                    'Smooth K',
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
                    controller: smoothKController,
                    onChanged: (value) {
                      final parsed =
                      int.tryParse(value);

                      if (parsed != null &&
                          parsed > 0) {
                        tempSmoothK =
                            parsed;
                      }
                    },
                  ),
                )
              ],
            ),


            const SizedBox(height: 16,),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Smooth D',
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
                    controller: smoothDController,
                    onChanged: (value) {
                      final parsed =
                      int.tryParse(value);

                      if (parsed != null &&
                          parsed > 0) {
                        tempSmoothD =
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
                        value: tempShowK,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowK =
                            !tempShowK;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'K%',
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
                    color: tempKColor,
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
                  colors: stochColors,
                  onColorSelected: (color) {

                    setState(() {

                      tempKColor = color;

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
                        value: tempShowD,
                        dark: dark,
                        onTap: () {
                          setState(() {
                            tempShowD =
                            !tempShowD;
                          });
                        },
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'D%',
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
                    color: tempDColor,
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
                  colors: stochColors,
                  onColorSelected: (color) {

                    setState(() {

                      tempDColor = color;

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
                      ref.read(stochRsiProvider.notifier)
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
                      ref.read(
                        stochRsiProvider.notifier,
                      );

                      notifier.updateRsiLength(
                        tempRsiLength,
                      );

                      notifier.updateStochLength(
                        tempStochLength,
                      );

                      notifier.updateSmoothK(
                        tempSmoothK,
                      );

                      notifier.updateSmoothD(
                        tempSmoothD,
                      );

                      notifier.updateKColor(
                        tempKColor,
                      );

                      notifier.updateDColor(
                        tempDColor,
                      );

                      if (
                      settings.showK != tempShowK
                      ) {
                        notifier.toggleK();
                      }

                      if (
                      settings.showD != tempShowD
                      ) {
                        notifier.toggleD();
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
