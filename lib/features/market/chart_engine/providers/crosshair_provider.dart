import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crosshairProvider = NotifierProvider<CrosshairNotifier, CrosshairState>(
  CrosshairNotifier.new,
);

class CrosshairState {
  final bool visible;

  final Offset? position;

  CrosshairState({required this.visible, required this.position});

  CrosshairState copyWith({bool? visible, Offset? position}) {
    return CrosshairState(
      visible: visible ?? this.visible,
      position: position ?? this.position,
    );
  }
}

class CrosshairNotifier extends Notifier<CrosshairState> {
  @override
  CrosshairState build() {
    return CrosshairState(visible: false, position: null);
  }

  void toggle(Offset position) {
    if (state.visible) {
      state = CrosshairState(visible: false, position: null);

      return;
    }

    state = CrosshairState(visible: true, position: position);
  }

  void update(Offset position) {
    if (!state.visible) return;

    state = state.copyWith(position: position);
  }
}
