import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/stoch_rsi_setting_model.dart';

final stochRsiProvider = NotifierProvider<
    StochRsiNotifier,
    StochRsiSettingsModel>(
  StochRsiNotifier.new,
);

class StochRsiNotifier
    extends Notifier<StochRsiSettingsModel> {

  @override
  StochRsiSettingsModel build() {

    return const StochRsiSettingsModel(
      rsiLength: 14,

      stochLength: 14,

      smoothK: 3,

      smoothD: 3,

      showK: true,

      showD: true,

      kColor: Colors.yellow,

      dColor: Colors.blue,
    );
  }

  void updateRsiLength(
      int value,
      ) {

    state = state.copyWith(
      rsiLength: value,
    );
  }

  void updateStochLength(
      int value,
      ) {

    state = state.copyWith(
      stochLength: value,
    );
  }

  void updateSmoothK(
      int value,
      ) {

    state = state.copyWith(
      smoothK: value,
    );
  }

  void updateSmoothD(
      int value,
      ) {

    state = state.copyWith(
      smoothD: value,
    );
  }

  void toggleK() {

    state = state.copyWith(
      showK: !state.showK,
    );
  }

  void toggleD() {

    state = state.copyWith(
      showD: !state.showD,
    );
  }

  void updateKColor(
      Color color,
      ) {

    state = state.copyWith(
      kColor: color,
    );
  }

  void updateDColor(
      Color color,
      ) {

    state = state.copyWith(
      dColor: color,
    );
  }

  void reset() {

    state = build();
  }
}