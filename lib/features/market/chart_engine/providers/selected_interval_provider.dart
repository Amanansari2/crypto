import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedIntervalProvider =

NotifierProvider<
    SelectedIntervalNotifier,
    String
>(

  SelectedIntervalNotifier.new,
);

class SelectedIntervalNotifier
    extends Notifier<String> {

  @override
  String build() {

    return '1m';
  }

  void change(
      String interval,
      ) {

    state = interval;
  }
}