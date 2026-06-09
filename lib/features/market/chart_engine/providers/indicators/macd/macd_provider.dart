import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/macd_setting_model.dart';

final macdProvider = NotifierProvider<
    MacdNotifier,
    MacdSettingsModel>(
  MacdNotifier.new,
);

class MacdNotifier
    extends Notifier<MacdSettingsModel> {

  @override
  MacdSettingsModel build() {

    return const MacdSettingsModel(
      fastPeriod: 12,
      slowPeriod: 26,
      signalPeriod: 9,

      macdColor: Colors.blue,
      signalColor: Colors.orange,

      positiveHistogramColor:
      Colors.green,

      negativeHistogramColor:
      Colors.red,
    );
  }

  void updateFastPeriod(
      int value,
      ) {

    state =
        state.copyWith(
          fastPeriod: value,
        );
  }

  void updateSlowPeriod(
      int value,
      ) {

    state =
        state.copyWith(
          slowPeriod: value,
        );
  }

  void updateSignalPeriod(
      int value,
      ) {

    state =
        state.copyWith(
          signalPeriod: value,
        );
  }

  void updateMacdColor(
      Color color,
      ) {

    state =
        state.copyWith(
          macdColor: color,
        );
  }

  void updateSignalColor(
      Color color,
      ) {

    state =
        state.copyWith(
          signalColor: color,
        );
  }

  void toggle() {

    state =
        state.copyWith(
          enabled: !state.enabled,
        );
  }

  void toggleMacdLine() {

    state = state.copyWith(
      showMacdLine:
      !state.showMacdLine,
    );
  }

  void toggleSignalLine() {

    state = state.copyWith(
      showSignalLine:
      !state.showSignalLine,
    );
  }

  void reset() {

    state = const MacdSettingsModel(
      fastPeriod: 12,
      slowPeriod: 26,
      signalPeriod: 9,

      macdColor: Colors.blue,
      signalColor: Colors.orange,

      positiveHistogramColor:
      Colors.green,

      negativeHistogramColor:
      Colors.red,

      showMacdLine: true,
      showSignalLine: true,
    );
  }
}