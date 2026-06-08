import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/rsi_setting_model.dart';

final rsiProvider = NotifierProvider<
    RsiNotifier,
    List<RsiSettingsModel>
>(
  RsiNotifier.new,
);

class RsiNotifier
    extends Notifier<List<RsiSettingsModel>> {

  @override
  List<RsiSettingsModel> build() {

    return const [

      RsiSettingsModel(
        period: 6,
        color: Colors.yellow,
      ),

      RsiSettingsModel(
        period: 12,
        color: Colors.blue,
      ),

      RsiSettingsModel(
        period: 24,
        color: Colors.purple,
      ),
    ];
  }

  void updatePeriod(
      int index,
      int period,
      ) {

    final current = [...state];

    current[index] =
        current[index].copyWith(
          period: period,
        );

    state = current;
  }

  void updateColor(
      int index,
      Color color,
      ) {

    final current = [...state];

    current[index] =
        current[index].copyWith(
          color: color,
        );

    state = current;
  }

  void toggle(
      int index,
      ) {

    final current = [...state];

    current[index] =
        current[index].copyWith(
          enabled: !current[index].enabled,
        );

    state = current;
  }

  void reset() {

    state = const [

      RsiSettingsModel(
        period: 6,
        color: Colors.yellow,
      ),

      RsiSettingsModel(
        period: 12,
        color: Colors.blue,
      ),

      RsiSettingsModel(
        period: 24,
        color: Colors.purple,
      ),
    ];
  }
}