import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class IntervalStorage {

  static const String customIntervalsKey =
      'custom_intervals';

  static const String selectedIntervalsKey =
      'selected_intervals';

  Future<void> saveCustomIntervals(
      List<Map<String, dynamic>> data,
      ) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      customIntervalsKey,
      jsonEncode(data),
    );
  }

  Future<void> saveSelectedIntervals(
      List<Map<String, dynamic>> data,
      ) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      selectedIntervalsKey,
      jsonEncode(data),
    );
  }

  Future<String?> loadCustomIntervals() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(
      customIntervalsKey,
    );
  }

  Future<String?> loadSelectedIntervals() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(
      selectedIntervalsKey,
    );
  }
}