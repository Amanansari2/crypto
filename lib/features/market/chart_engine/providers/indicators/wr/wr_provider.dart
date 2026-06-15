import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/wr_setting_model.dart';

final wrProvider = NotifierProvider<
    WrNotifier,
    WrSettingsModel>(
  WrNotifier.new,
);

class WrNotifier
    extends Notifier<WrSettingsModel> {

  @override
  WrSettingsModel build() {

    return const WrSettingsModel(
      period: 14,
      color: Colors.yellow,
    );
  }

  void updatePeriod(
      int period,
      ) {

    state = state.copyWith(
      period: period,
    );
  }

  void updateColor(
      Color color,
      ) {

    state = state.copyWith(
      color: color,
    );
  }

  void reset() {

    state = build();
  }
}