import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/indicators/indicator_type.dart';
final activeIndicatorsProvider =

NotifierProvider<
    ActiveIndicatorsNotifier,
    List<IndicatorType>
>(
  ActiveIndicatorsNotifier.new,
);

class ActiveIndicatorsNotifier extends Notifier<List<IndicatorType>> {

  @override
  List<IndicatorType> build() {

    return const [
      IndicatorType.stoch
    ];
  }

  void toggle(
      IndicatorType type,
      ) {
    final current = [...state];
    if (current.contains(type)) {
      current.remove(type);
    } else {
      current.add(type);
    }

    state = current;
  }

  bool isActive(
      IndicatorType type,
      ) {
    return state.contains(type);
  }

  void add(
      IndicatorType type,
      ) {

    if (state.contains(type)) {
      return;
    }

    state = [...state, type,];
  }

  void remove(
      IndicatorType type,
      ) {
    state = state.where(
          (e) => e != type,).toList();
  }

  void clearAll() {

    state = [];
  }
}