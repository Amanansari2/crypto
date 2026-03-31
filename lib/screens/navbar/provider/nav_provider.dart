//
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class NavState {
//   final int index;
//
//   const NavState({this.index = 0});
//
//   NavState copyWith({int? index}) {
//     return NavState(index: index ?? this.index);
//   }
// }
//
// class NavNotifier extends Notifier<NavState> {
//   @override
//   NavState build() {
//     return const NavState();
//   }
//
//   void setIndex(int newIndex) {
//     state = state.copyWith(index: newIndex);
//   }
// }
//
// final navProvider =
// NotifierProvider<NavNotifier, NavState>(NavNotifier.new);

import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
}