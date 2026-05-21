import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crosshairProvider = NotifierProvider<CrosshairNotifier, CrosshairState>(
  CrosshairNotifier.new,
);

class CrosshairState {
  final bool visible;

  final Offset? position;
  final int? candleIndex;

  CrosshairState(
      {required this.visible, required this.position, required this.candleIndex});

  CrosshairState copyWith({bool? visible, Offset? position, int? candleIndex}) {
    return CrosshairState(
      visible: visible ?? this.visible,
      position: position ?? this.position,
        candleIndex: candleIndex ?? this.candleIndex
    );
  }
}

class CrosshairNotifier extends Notifier<CrosshairState> {
  @override
  CrosshairState build() {
    return CrosshairState(visible: false, position: null, candleIndex: null);
  }

  void toggle(Offset position) {
    if (state.visible) {
      state = CrosshairState(visible: false, position: null, candleIndex: null);

      return;
    }

    state =
        CrosshairState(visible: true, position: position, candleIndex: null);
  }

  void update({

    required Offset position,

    required int candleIndex,

  }) {

    if (!state.visible) return;

    state = state.copyWith(
      position: position,
      candleIndex: candleIndex,
    );
  }
}
