import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/models/indicators/roc_setting_model.dart';

final rocProvider = NotifierProvider<
    RocNotifier,
    RocSettingsModel>(
  RocNotifier.new,
);

class RocNotifier
    extends Notifier<RocSettingsModel> {

  @override
  RocSettingsModel build() {

    return const RocSettingsModel(
      rocPeriod: 12,

      maPeriod: 6,

      showRoc: true,

      showMaRoc: true,

      rocColor: Colors.yellow,

      maRocColor: Colors.blue,
    );
  }

  void updateRocPeriod(
      int period,
      ) {

    state = state.copyWith(
      rocPeriod: period,
    );
  }

  void updateMaPeriod(
      int period,
      ) {

    state = state.copyWith(
      maPeriod: period,
    );
  }

  void toggleRoc() {

    state = state.copyWith(
      showRoc: !state.showRoc,
    );
  }

  void toggleMaRoc() {

    state = state.copyWith(
      showMaRoc: !state.showMaRoc,
    );
  }

  void updateRocColor(
      Color color,
      ) {

    state = state.copyWith(
      rocColor: color,
    );
  }

  void updateMaRocColor(
      Color color,
      ) {

    state = state.copyWith(
      maRocColor: color,
    );
  }

  void reset() {

    state = build();
  }
}