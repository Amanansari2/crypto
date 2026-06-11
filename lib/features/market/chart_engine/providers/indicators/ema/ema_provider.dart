import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/ema_setting_model.dart';

final emaProvider = NotifierProvider<
    EmaNotifier,
    List<EmaSettingsModel>>(
  EmaNotifier.new,
);

class EmaNotifier
    extends Notifier<List<EmaSettingsModel>> {

  @override
  List<EmaSettingsModel> build() {

    return const [

      EmaSettingsModel(
        period: 7,
        color: Colors.yellow,
        enabled: true,
      ),

      EmaSettingsModel(
        period: 25,
        color: Colors.blue,
        enabled: true,
      ),

      EmaSettingsModel(
        period: 99,
        color: Colors.purple,
        enabled: true,
      ),

      EmaSettingsModel(
        period: 1,
        color: Colors.green,
        enabled: false,
      ),

      EmaSettingsModel(
        period: 1,
        color: Colors.pink,
        enabled: false,
      ),

      EmaSettingsModel(
        period: 1,
        color: Colors.cyan,
        enabled: false,
      ),

      EmaSettingsModel(
        period: 1,
        color: Colors.deepPurple,
        enabled: false,
      ),

      EmaSettingsModel(
        period: 1,
        color: Colors.deepOrange,
        enabled: false,
      ),

      EmaSettingsModel(
        period: 1,
        color: Color(0xFFD946EF),
        enabled: false,
      ),

      EmaSettingsModel(
        period: 1,
        color: Colors.lime,
        enabled: false,
      ),
    ];
  }

  void updatePeriod(
      int index,
      int period,
      ) {

    final updated =
    [...state];

    updated[index] =
        updated[index].copyWith(
          period: period,
        );

    state = updated;
  }

  void updateColor(
      int index,
      Color color,
      ) {

    final updated =
    [...state];

    updated[index] =
        updated[index].copyWith(
          color: color,
        );

    state = updated;
  }

  void toggle(
      int index,
      ) {

    final updated =
    [...state];

    updated[index] =
        updated[index].copyWith(
          enabled:
          !updated[index].enabled,
        );

    state = updated;
  }

  void reset() {

    state = build();
  }

  void replaceAll(
      List<EmaSettingsModel> settings,
      ) {
    state = [...settings];
  }
}