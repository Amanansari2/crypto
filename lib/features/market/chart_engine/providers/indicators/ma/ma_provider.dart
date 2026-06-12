import 'package:crypto_app/features/market/chart_engine/settings/models/indicators/ma_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final maProvider = NotifierProvider<
    MaNotifier,
    List<MaSettingsModel>>(
  MaNotifier.new,
);

class MaNotifier
    extends Notifier<List<MaSettingsModel>> {

  @override
  List<MaSettingsModel> build() {

    return const [

      MaSettingsModel(
        period: 7,
        color: Colors.yellow,
        enabled: true,
      ),

      MaSettingsModel(
        period: 25,
        color: Colors.blue,
        enabled: true,
      ),

      MaSettingsModel(
        period: 99,
        color: Colors.purple,
        enabled: true,
      ),

      MaSettingsModel(
        period: 1,
        color: Colors.green,
        enabled: false,
      ),

      MaSettingsModel(
        period: 1,
        color: Colors.pink,
        enabled: false,
      ),

      MaSettingsModel(
        period: 1,
        color: Colors.cyan,
        enabled: false,
      ),

      MaSettingsModel(
        period: 1,
        color: Colors.deepPurple,
        enabled: false,
      ),

      MaSettingsModel(
        period: 1,
        color: Colors.deepOrange,
        enabled: false,
      ),

      MaSettingsModel(
        period: 1,
        color: Color(0xFFD946EF),
        enabled: false,
      ),

      MaSettingsModel(
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
      List<MaSettingsModel> settings,
      ) {
    state = [...settings];
  }
}