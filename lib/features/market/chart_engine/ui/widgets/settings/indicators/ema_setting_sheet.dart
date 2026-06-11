import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_strings.dart';
import '../../../../providers/indicators/ema/ema_provider.dart';
import '../../../../settings/models/indicators/ema_setting_model.dart';
import '../widget/indicator_checkbox.dart';
import '../widget/indicator_color_box.dart';
import '../widget/indicator_color_picker.dart';
import '../widget/indicator_textfield.dart';

class EmaSettingSheet extends ConsumerStatefulWidget {
  const EmaSettingSheet({super.key});

  @override
  ConsumerState<EmaSettingSheet> createState() => _EmaSettingSheetState();
}

class _EmaSettingSheetState extends ConsumerState<EmaSettingSheet> {
  bool initialized = false;

  int? openedColorPickerIndex;

  late List<EmaSettingsModel> tempSettings;

  final List<TextEditingController> controllers = [];

  static const emaColors = [
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

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final settings = ref.watch(emaProvider);

    if (!initialized) {
      tempSettings = settings.map((e) => e.copyWith()).toList();

      controllers.clear();

      for (final item in tempSettings) {
        controllers.add(TextEditingController(text: item.period.toString()));
      }

      initialized = true;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? AppColors.darkBg : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EMA',
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
                  child: Text('Value',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: dark ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Text('Color',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: dark ? AppColors.white : AppColors.black,
                    ),),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tempSettings.length,
                itemBuilder: (context, index) {
                  final item = tempSettings[index];

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                IndicatorCheckBox(
                                  value: item.enabled,
                                  dark: dark,
                                  onTap: () {
                                    setState(() {
                                      tempSettings[index] = item.copyWith(
                                        enabled: !item.enabled,
                                      );
                                    });
                                  },
                                ),

                                const SizedBox(width: 10),

                                Text(
                                  'EMA',
                                  style: TextStyle(
                                    color: dark
                                        ? AppColors.white
                                        : AppColors.black,
                                    fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: IndicatorTextField(
                              dark: dark,
                              controller: controllers[index],
                              onChanged: (value) {
                                final parsed = int.tryParse(value);

                                if (parsed != null && parsed > 0) {
                                  tempSettings[index] = item.copyWith(
                                    period: parsed,
                                  );
                                }
                              },
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            flex: 1,
                            child: IndicatorColorBox(
                              dark: dark,
                              color: item.color,
                              onTap: () {
                                setState(() {
                                  openedColorPickerIndex =
                                      openedColorPickerIndex == index
                                      ? null
                                      : index;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      if (openedColorPickerIndex == index)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 150),
                          child: IndicatorColorPicker(
                            colors: emaColors,
                            onColorSelected: (color) {
                              setState(() {
                                tempSettings[index] = item.copyWith(
                                  color: color,
                                );

                                openedColorPickerIndex = null;
                              });
                            },
                          ),
                        ),

                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

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
                      ref.read(emaProvider.notifier).reset();

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
                      ref.read(emaProvider.notifier).replaceAll(tempSettings);

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
