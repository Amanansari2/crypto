import 'package:flutter/material.dart';

class EmaSettingsModel {

  final int period;

  final Color color;

  final bool enabled;

  const EmaSettingsModel({
    required this.period,
    required this.color,
    required this.enabled,
  });

  EmaSettingsModel copyWith({
    int? period,
    Color? color,
    bool? enabled,
  }) {

    return EmaSettingsModel(
      period:
      period ?? this.period,

      color:
      color ?? this.color,

      enabled:
      enabled ?? this.enabled,
    );
  }
}