import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/indicators/indicator_type.dart';

final overlayIndicatorProvider =
NotifierProvider<
    OverlayIndicatorNotifier,
    IndicatorType?
>(
  OverlayIndicatorNotifier.new,
);

class OverlayIndicatorNotifier
    extends Notifier<IndicatorType?> {

  @override
  IndicatorType? build() {
    return null;
  }

  void toggle(
      IndicatorType type,
      ) {

    if (state == type) {

      state = null;

    } else {

      state = type;
    }
  }
}