import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/interval_model.dart';

final selectedIntervalProvider =

NotifierProvider<
    SelectedIntervalNotifier,
    IntervalModel
>(

  SelectedIntervalNotifier.new,
);

class SelectedIntervalNotifier

    extends Notifier<IntervalModel> {

  @override
  IntervalModel build() {

    return const IntervalModel(

      label: '15m',

      value: '15m',
    );
  }

  void change(
      IntervalModel interval,
      ) {

    state = interval;
  }
}