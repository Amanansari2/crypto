import 'dart:convert';

import 'package:crypto_app/features/market/chart_engine/data/local/interval_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/interval_model.dart';

final intervalsProvider =

NotifierProvider<
    IntervalsNotifier,
    List<IntervalModel>
>(

  IntervalsNotifier.new,
);

class IntervalsNotifier

    extends Notifier<List<IntervalModel>> {

  final _storage = IntervalStorage();

  @override
  List<IntervalModel> build() {

    _loadSelectedIntervals();

    return const [

      IntervalModel(
        label: '15m',
        value: '15m',
      ),

      IntervalModel(
        label: '30m',
        value: '30m',
      ),

      IntervalModel(
        label: '1h',
        value: '1h',
      ),

      IntervalModel(
        label: '4h',
        value: '4h',
      ),

      IntervalModel(
        label: '1D',
        value: '1d',
      ),
    ];
  }

  Future<void> _loadSelectedIntervals() async {

    final raw = await _storage.loadSelectedIntervals();

    if (raw == null) return;

    final decoded = jsonDecode(raw) as List;

    state = decoded.map((e) => IntervalModel.fromJson(
        e as Map<String, dynamic>,),).toList();
  }

  Future<void> _saveSelectedIntervals() async {

    await _storage.saveSelectedIntervals(
      state.map((e) => e.toJson()).toList(),
    );
  }

  /// 🔥 add/replace custom interval
  void selectInterval(
      IntervalModel interval,
      ) {
    final current = [...state];
    final exists = current.any(
          (e) => e.value == interval.value,
    );
    if (exists) {
      state = current.where(
            (e) => e.value != interval.value,
      ).toList();
      _saveSelectedIntervals();
      return;
    }

    if (current.length >= 5) {
      return;
    }
    current.add(interval);
    state = current;
    _saveSelectedIntervals();
  }

  /// 🔥 remove custom interval
  void removeCustom(String value,) {
    state = state.where((e) => e.value != value,).toList();
    _saveSelectedIntervals();
  }

  void resetToDefault() {

    state = const [

      IntervalModel(
        label: '15m',
        value: '15m',
      ),
      IntervalModel(
        label: '30m',
        value: '30m',
      ),
      IntervalModel(
        label: '1h',
        value: '1h',
      ),

      IntervalModel(
        label: '4h',
        value: '4h',
      ),

      IntervalModel(
        label: '1D',
        value: '1d',
      ),
    ];
    _saveSelectedIntervals();

  }

  void replaceAll(
      List<IntervalModel> intervals,
      ) {

    state = [...intervals];

    _saveSelectedIntervals();
  }
}