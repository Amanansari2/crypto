import 'package:flutter/material.dart';

class RocSettingsModel {

  final int rocPeriod;

  final int maPeriod;

  final bool showRoc;

  final bool showMaRoc;

  final Color rocColor;

  final Color maRocColor;

  const RocSettingsModel({
    required this.rocPeriod,
    required this.maPeriod,
    required this.showRoc,
    required this.showMaRoc,
    required this.rocColor,
    required this.maRocColor,
  });

  RocSettingsModel copyWith({
    int? rocPeriod,
    int? maPeriod,
    bool? showRoc,
    bool? showMaRoc,
    Color? rocColor,
    Color? maRocColor,
  }) {
    return RocSettingsModel(
      rocPeriod: rocPeriod ?? this.rocPeriod,
      maPeriod: maPeriod ?? this.maPeriod,
      showRoc: showRoc ?? this.showRoc,
      showMaRoc: showMaRoc ?? this.showMaRoc,
      rocColor: rocColor ?? this.rocColor,
      maRocColor: maRocColor ?? this.maRocColor,
    );
  }
}