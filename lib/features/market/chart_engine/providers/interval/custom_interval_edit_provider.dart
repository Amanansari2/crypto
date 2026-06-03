import 'package:flutter_riverpod/flutter_riverpod.dart';

final customIntervalEditProvider =
NotifierProvider<
    CustomIntervalEditNotifier,
    bool>(
  CustomIntervalEditNotifier.new,
);

class CustomIntervalEditNotifier
    extends Notifier<bool> {

  @override
  bool build() => false;

  void enable() => state = true;

  void disable() => state = false;

  void toggle() => state = !state;
}