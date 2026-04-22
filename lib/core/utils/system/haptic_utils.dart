import 'package:flutter/services.dart';

class HapticUtils {
  static void vibrate([Duration duration = const Duration(milliseconds: 100)]) {
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }
}
