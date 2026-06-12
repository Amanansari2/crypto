import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/boll_setting_model.dart';

final bollProvider = NotifierProvider<
    BollNotifier,
    BollSettingsModel>(
  BollNotifier.new,
);

class BollNotifier
    extends Notifier<BollSettingsModel> {

  static const _default =
  BollSettingsModel(
    period: 21,
    bandwidth: 2.0,

    upperColor: Colors.yellow,

    middleColor: Colors.blue,

    lowerColor: Color(
      0xFF9FA8DA,
    ),

    showUpper: true,
    showMiddle: true,
    showLower: true,
  );

  @override
  BollSettingsModel build() {
    return _default;
  }

  void updatePeriod(
      int period,
      ) {

    state = state.copyWith(
      period: period,
    );
  }

  void updateBandwidth(
      double bandwidth,
      ) {

    state = state.copyWith(
      bandwidth: bandwidth,
    );
  }

  void updateUpperColor(
      Color color,
      ) {

    state = state.copyWith(
      upperColor: color,
    );
  }

  void updateMiddleColor(
      Color color,
      ) {

    state = state.copyWith(
      middleColor: color,
    );
  }

  void updateLowerColor(
      Color color,
      ) {

    state = state.copyWith(
      lowerColor: color,
    );
  }

  void toggleUpper() {

    state = state.copyWith(
      showUpper: !state.showUpper,
    );
  }

  void toggleMiddle() {

    state = state.copyWith(
      showMiddle: !state.showMiddle,
    );
  }

  void toggleLower() {

    state = state.copyWith(
      showLower: !state.showLower,
    );
  }

  void reset() {
    state = _default;
  }
}