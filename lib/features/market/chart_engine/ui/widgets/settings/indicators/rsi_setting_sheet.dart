import 'package:crypto_app/core/utils/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../providers/indicators/rsi/rsi_provider.dart';

class RsiSettingsSheet extends ConsumerStatefulWidget {
  const RsiSettingsSheet({super.key});

  @override
  ConsumerState<RsiSettingsSheet> createState() => _RsiSettingsSheetState();
}

class _RsiSettingsSheetState extends ConsumerState<RsiSettingsSheet> {
  late List<int> tempPeriods;
  late List<Color> tempColors;
  late List<bool> tempEnabled;
  bool initialized = false;
  int? openedColorPickerIndex;
  late List<TextEditingController> periodControllers;

  @override
  void dispose() {
    for (final controller in periodControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final settings = ref.watch(rsiProvider);

    if (!initialized) {
      tempPeriods = settings.map((e) => e.period).toList();

      tempColors = settings.map((e) => e.color).toList();

      tempEnabled = settings.map((e) => e.enabled).toList();

      periodControllers = settings.map((e) {
        return TextEditingController(text: e.period.toString());
      }).toList();

      initialized = true;
    }

    const rsiColors = [
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
              'RSI',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  flex: 3,
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
                  flex: 2,
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

            const SizedBox(height: 12),

            ...List.generate(settings.length, (index) {
              final item = settings[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tempEnabled[index] =
                                    !tempEnabled[index];
                                  });
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: tempEnabled[index]
                                        ? (dark ? AppColors.blue.withOpacity(0.08) : Colors.blue)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: tempEnabled[index]
                                          ? (dark ? AppColors.blue.withOpacity(0.4) : Colors.grey.withOpacity(0.4))
                                          : Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: tempEnabled[index]
                                      ? const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                              ),

                              SizedBox(width: 10,),

                              Text(
                                'RSI',
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
                          child: Container(
                            padding: EdgeInsets.all(2),
                            height: 44,
                            decoration: BoxDecoration(
                              color: dark
                                  ? AppColors.blue.withOpacity(0.08)
                                  : AppColors.white,

                              borderRadius: BorderRadius.circular(8.r),

                              border: Border.all(
                                color: dark
                                    ? AppColors.blue.withOpacity(0.4)
                                    : Colors.grey.withOpacity(0.4),
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
                            child: Center(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                    cursorColor: dark ? AppColors.white : AppColors.black,
                                    selectionHandleColor: dark
                                        ? Colors.white
                                        : Colors.black,

                                    selectionColor: (dark
                                        ? Colors.white
                                        : Colors.black)
                                        .withOpacity(0.25),
                                  )
                                ),
                                child: TextFormField(
                                  controller: periodControllers[index],
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.top,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: dark
                                        ? AppColors.white
                                        : AppColors.black,
                                    fontSize: 16,
                                  ),
                                  cursorColor: dark ? AppColors.white : AppColors.black,
                                  decoration: const InputDecoration(
                                    filled: false,
                                    fillColor: Colors.transparent,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      bottom: 8,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    final parsed = int.tryParse(value);

                                    if (parsed != null && parsed > 0) {
                                      tempPeriods[index] = parsed;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                openedColorPickerIndex =
                                    openedColorPickerIndex == index
                                    ? null
                                    : index;
                              });
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: dark
                                    ? AppColors.blue.withOpacity(0.08)
                                    : AppColors.white,

                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: dark
                                      ? AppColors.blue.withOpacity(0.4)
                                      : Colors.grey.withOpacity(0.4),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: tempColors[index],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  const Icon(Icons.keyboard_arrow_down, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (openedColorPickerIndex == index)
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 150),
                        child: Wrap(
                          spacing: 18,
                          runSpacing: 10,
                          children: rsiColors.map((color) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  tempColors[index] = color;
                                  openedColorPickerIndex = null;
                                });
                              },
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

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
                      ref.read(rsiProvider.notifier).reset();

                      setState(() {
                        tempPeriods = [6, 12, 24];

                        tempColors = [Colors.yellow, Colors.blue, Colors.purple];

                        tempEnabled = [true, true, true];

                        periodControllers[0].text = '6';

                        periodControllers[1].text = '12';

                        periodControllers[2].text = '24';
                      });
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
                      final notifier = ref.read(rsiProvider.notifier);

                      for (int i = 0; i < settings.length; i++) {
                        notifier.updatePeriod(i, tempPeriods[i]);

                        notifier.updateColor(i, tempColors[i]);

                        final currentEnabled = settings[i].enabled;

                        if (currentEnabled != tempEnabled[i]) {
                          notifier.toggle(i);
                        }
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
