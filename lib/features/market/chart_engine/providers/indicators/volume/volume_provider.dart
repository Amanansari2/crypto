import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/volume_setting_model.dart';

final volumeProvider = NotifierProvider<
    VolumeNotifier,
    VolumeSettingsModel>(
  VolumeNotifier.new,
);

class VolumeNotifier
    extends Notifier<VolumeSettingsModel> {

  @override
  VolumeSettingsModel build() {

    return const VolumeSettingsModel(
      upColor: Colors.green,
      downColor: Colors.red,
      enabled: true,
      ma1Period: 5,
      ma2Period: 10,

      ma1Color: Colors.yellow,
      ma2Color: Colors.blue,

      showMa1: true,
      showMa2: true,
    );
  }

  void toggle() {

    state = state.copyWith(
      enabled: !state.enabled,
    );
  }

  void updateUpColor(
      Color color,
      ) {

    state = state.copyWith(
      upColor: color,
    );
  }

  void updateDownColor(
      Color color,
      ) {

    state = state.copyWith(
      downColor: color,
    );
  }

  void updateMa1Period(int value) {
    state = state.copyWith(
      ma1Period: value,
    );
  }

  void updateMa2Period(int value) {
    state = state.copyWith(
      ma2Period: value,
    );
  }

  void updateMa1Color(Color color) {
    state = state.copyWith(
      ma1Color: color,
    );
  }

  void updateMa2Color(Color color) {
    state = state.copyWith(
      ma2Color: color,
    );
  }

  void toggleMa1() {
    state = state.copyWith(
      showMa1: !state.showMa1,
    );
  }

  void toggleMa2() {
    state = state.copyWith(
      showMa2: !state.showMa2,
    );
  }

  void reset() {

    state = const VolumeSettingsModel(
      upColor: Colors.green,
      downColor: Colors.red,
      enabled: true,
      ma1Period: 5,
      ma2Period: 10,

      ma1Color: Colors.yellow,
      ma2Color: Colors.blue,

      showMa1: true,
      showMa2: true,
    );
  }
}