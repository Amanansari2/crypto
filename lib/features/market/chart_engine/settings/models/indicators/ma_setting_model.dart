import 'package:flutter/material.dart';

class MaSettingsModel {

  final int period;

  final Color color;

  final bool enabled;

  const MaSettingsModel({
    required this.period,
    required this.color,
    required this.enabled,
  });

  MaSettingsModel copyWith({
    int? period,
    Color? color,
    bool? enabled,
  }) {

    return MaSettingsModel(
      period:
      period ?? this.period,

      color:
      color ?? this.color,

      enabled:
      enabled ?? this.enabled,
    );
  }
}