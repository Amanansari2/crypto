

import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavState {
  final int index;

  const NavState({this.index = 0});

  NavState copyWith({int? index}) {
    return NavState(index: index ?? this.index);
  }
}

class NavNotifier extends Notifier<NavState> {
  @override
  NavState build() {
    return const NavState();
  }

  void setIndex(int newIndex) {
    state = state.copyWith(index: newIndex);
  }
}

final navProvider =
    NotifierProvider<NavNotifier, NavState>(NavNotifier.new);