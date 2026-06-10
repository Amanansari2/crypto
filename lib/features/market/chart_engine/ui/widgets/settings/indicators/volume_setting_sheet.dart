import 'dart:ui';

import 'package:crypto_app/features/market/chart_engine/providers/indicators/volume/volume_provider.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_checkbox.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_color_box.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_color_picker.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/widget/indicator_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_strings.dart';

class VolumeSettingSheet extends ConsumerStatefulWidget {
  const VolumeSettingSheet({super.key});

  @override
  ConsumerState<VolumeSettingSheet> createState() => _VolumeSettingSheetState();
}

class _VolumeSettingSheetState extends ConsumerState<VolumeSettingSheet> {

  bool initialized = false;
  int? openedColorPickerIndex;

  late int tempMa1Period;
  late int tempMa2Period;

  late Color tempMa1Color;
  late Color tempMa2Color;

  late bool tempShowMa1;
  late bool tempShowMa2;

  late TextEditingController ma1Controller;
  late TextEditingController ma2Controller;

  @override
  void dispose() {
     ma1Controller.dispose();
     ma2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
  final settings = ref.watch(volumeProvider);

  if(!initialized){
    tempMa1Period = settings.ma1Period;
    tempMa2Period = settings.ma2Period;

    tempMa1Color = settings.ma1Color;
    tempMa2Color = settings.ma2Color;

    tempShowMa1 = settings.showMa1;
    tempShowMa2 = settings.showMa2;

    ma1Controller =
        TextEditingController(
          text: tempMa1Period.toString(),
        );

    ma2Controller =
        TextEditingController(
          text: tempMa2Period.toString(),
        );
    initialized = true;
  }

    const volColors = [
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
              'Volume',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16,),

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
            const SizedBox(height: 16,),

            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        IndicatorCheckBox(
                            value: tempShowMa1,
                            dark: dark,
                            onTap: (){
                              setState(() {
                                tempShowMa1 = !tempShowMa1;
                              });
                            }),

                        const SizedBox(width: 10,),
                        Text(
                          'MAVOL.1',
                          style: TextStyle(
                            color: dark
                                ? AppColors.white
                                : AppColors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )),

                Expanded(
                    flex: 2,
                    child: IndicatorTextField(
                        dark: dark,
                        controller: ma1Controller,
                        onChanged: (value){
                          final parsed = int.tryParse(value);

                          if(parsed != null && parsed >0){
                            tempMa1Period = parsed;
                          }
                        })),

                const SizedBox(width: 20,),

                Expanded(
                    flex: 1,
                    child: IndicatorColorBox(
                        dark: dark,
                        color: tempMa1Color,
                        onTap: (){
                          setState(() {
                            openedColorPickerIndex =
                                openedColorPickerIndex == 0
                                ? null
                                    :0;
                          });
                        }))

              ],
            ),
            if(openedColorPickerIndex == 0 )
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 150,
                ),
               child: IndicatorColorPicker(
                   colors: volColors,
                   onColorSelected: (color){
                     setState(() {
                       tempMa1Color = color;
                       openedColorPickerIndex = null;
                     });
                   }),
              ),

            const SizedBox(height: 16,),

            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        IndicatorCheckBox(
                            value: tempShowMa2,
                            dark: dark,
                            onTap: (){
                              setState(() {
                                tempShowMa2 = !tempShowMa2;
                              });
                            }),

                        const SizedBox(width: 10,),
                        Text(
                          'MAVOL.2',
                          style: TextStyle(
                            color: dark
                                ? AppColors.white
                                : AppColors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: IndicatorTextField(
                        dark: dark,
                        controller: ma2Controller,
                        onChanged: (value){
                          final parsed = int.tryParse(value);

                          if(parsed != null && parsed >0){
                            tempMa2Period = parsed;
                          }
                        })),

                const SizedBox(width: 20,),

                Expanded(
                    flex: 1,
                    child: IndicatorColorBox(
                        dark: dark,
                        color: tempMa2Color,
                        onTap: (){
                          setState(() {
                            openedColorPickerIndex =
                            openedColorPickerIndex == 1
                                ? null
                                :1;
                          });
                        })),
              ],
            ),
            if(openedColorPickerIndex == 1 )
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 150,
                ),
                child: IndicatorColorPicker(
                    colors: volColors,
                    onColorSelected: (color){
                      setState(() {
                        tempMa2Color = color;
                        openedColorPickerIndex = null;
                      });
                    }),
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
                      ref.read(volumeProvider.notifier)
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
                        volumeProvider.notifier,
                      );

                      notifier.updateMa1Period(
                        tempMa1Period,
                      );

                      notifier.updateMa2Period(
                        tempMa2Period,
                      );

                      notifier.updateMa1Color(
                        tempMa1Color,
                      );

                      notifier.updateMa2Color(
                        tempMa2Color,
                      );

                      if (
                      settings.showMa1 !=
                          tempShowMa1
                      ) {
                        notifier.toggleMa1();
                      }

                      if (
                      settings.showMa2 !=
                          tempShowMa2
                      ) {
                        notifier.toggleMa2();
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
