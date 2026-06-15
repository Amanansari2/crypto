import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/kdj_setting_model.dart';

final kdjProvider = NotifierProvider<
    KdjNotifier,
    KdjSettingsModel>(
  KdjNotifier.new,
);

class KdjNotifier
    extends Notifier<KdjSettingsModel> {

  @override
  KdjSettingsModel build() {

    return const KdjSettingsModel(
      period: 9,

      ma1: 3,

      ma2: 3,

      showK: true,

      showD: true,

      showJ: true,

      kColor: Colors.yellow,

      dColor: Colors.blue,

      jColor: Color(0xFF9FA8DA),
    );
  }

  void updatePeriod(
      int period,
      ) {

    state = state.copyWith(
      period: period,
    );
  }

  void updateMa1(
      int value,
      ) {

    state = state.copyWith(
      ma1: value,
    );
  }

  void updateMa2(
      int value,
      ) {

    state = state.copyWith(
      ma2: value,
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

  void toggleJ() {

    state = state.copyWith(
      showJ: !state.showJ,
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

  void updateJColor(
      Color color,
      ) {

    state = state.copyWith(
      jColor: color,
    );
  }

  void reset() {

    state = build();
  }
}