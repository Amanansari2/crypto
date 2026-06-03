import 'dart:convert';
import 'dart:developer' as LogHelper;

import 'package:crypto_app/features/market/chart_engine/data/local/interval_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/all_intervals.dart';
import '../../core/models/interval_model.dart';

final customIntervalsProvider =

NotifierProvider<
    CustomIntervalsNotifier,
    List<IntervalModel>
>(
  CustomIntervalsNotifier.new,
);

class CustomIntervalsNotifier
    extends Notifier<List<IntervalModel>> {

  final _storage = IntervalStorage();

  @override
  List<IntervalModel> build() {
    _loadCustomIntervals();
    return [];
  }

  Future<void> _loadCustomIntervals() async {

    final raw = await _storage.loadCustomIntervals();
    if (raw == null) return;

    final decoded = jsonDecode(raw) as List;

    state = decoded.map((e) => IntervalModel.fromJson(
        e as Map<String, dynamic>,),).toList();
  }

  Future<void> _saveCustomIntervals() async {

    await _storage.saveCustomIntervals(
      state.map((e) => e.toJson()).toList(),
    );
  }

  bool addCustom(IntervalModel interval,) {
    if (state.length >= 12) {
      return false;
    }
    /// duplicate custom
    if (state.any(
          (e) => e.value == interval.value,
    )) {
      LogHelper.log('Duplicate Custom');
      return false;
    }
    /// already exists in default intervals
    final existsInDefault = [
      ...AllIntervals.minutes,
      ...AllIntervals.hours,
      ...AllIntervals.days,
    ].any(
          (e) => e.value == interval.value,
    );

    if (existsInDefault) {
      LogHelper.log('Exists In Default');
      return false;
    }

    state = [...state, interval];
     _saveCustomIntervals();
    LogHelper.log('Added Successfully');
    return true;
  }

  void removeCustom(
      String value,
      ) {

    state = state.where(
          (e) => e.value != value,).toList();
    _saveCustomIntervals();
  }

  void clearAll() {
    state = [];
    _saveCustomIntervals();
  }
}