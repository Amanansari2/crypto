import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/obv_setting_model.dart';

final obvProvider = NotifierProvider<
    ObvNotifier,
    ObvSettingsModel>(
  ObvNotifier.new,
);

class ObvNotifier
    extends Notifier<ObvSettingsModel> {

  @override
  ObvSettingsModel build() {

    return const ObvSettingsModel(
      maPeriod: 30,

      showObv: true,

      showMaObv: true,

      obvColor: Colors.yellow,

      maObvColor: Colors.blue,
    );
  }

  void updateMaPeriod(
      int period,
      ) {

    state = state.copyWith(
      maPeriod: period,
    );
  }

  void toggleObv() {

    state = state.copyWith(
      showObv: !state.showObv,
    );
  }

  void toggleMaObv() {

    state = state.copyWith(
      showMaObv: !state.showMaObv,
    );
  }

  void updateObvColor(
      Color color,
      ) {

    state = state.copyWith(
      obvColor: color,
    );
  }

  void updateMaObvColor(
      Color color,
      ) {

    state = state.copyWith(
      maObvColor: color,
    );
  }

  void reset() {

    state = build();
  }
}