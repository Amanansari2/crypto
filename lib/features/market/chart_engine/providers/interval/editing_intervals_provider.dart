import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/interval_model.dart';

final editingIntervalsProvider =
NotifierProvider<
    EditingIntervalsNotifier,
    List<IntervalModel>>(
  EditingIntervalsNotifier.new,
);

class EditingIntervalsNotifier
    extends Notifier<List<IntervalModel>> {

  @override
  List<IntervalModel> build() {
    return [];
  }

  void replaceAll(
      List<IntervalModel> intervals,
      ) {

    state = [...intervals];
  }

  void selectInterval(
      IntervalModel interval,
      ) {

    final current = [...state];

    final exists = current.any(
          (e) => e.value == interval.value,
    );

    if (exists) {
      state = current.where(
            (e) => e.value != interval.value,
      ).toList();
      return;
    }

    if (current.length >= 5) {
      return;
    }

    current.add(interval);

    state = current;
  }

  void removeInterval(
      String value,
      ) {

    state = state.where(
          (e) => e.value != value,
    ).toList();
  }

  void resetToDefault() {
    state = const [
      IntervalModel(label: '15m', value: '15m'),
      IntervalModel(label: '30m', value: '30m'),
      IntervalModel(label: '1h', value: '1h'),
      IntervalModel(label: '4h', value: '4h'),
      IntervalModel(label: '1D', value: '1d'),
    ];
  }
}