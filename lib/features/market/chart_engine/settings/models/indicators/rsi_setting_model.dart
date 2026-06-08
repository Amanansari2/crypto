import 'package:flutter/material.dart';

class RsiSettingsModel {

  final int period;

  final Color color;

  final bool enabled;

  const RsiSettingsModel({
    required this.period,
    required this.color,
    this.enabled = true,
  });

  RsiSettingsModel copyWith({
    int? period,
    Color? color,
    bool? enabled,
  }) {
    return RsiSettingsModel(
      period: period ?? this.period,
      color: color ?? this.color,
      enabled: enabled ?? this.enabled,
    );
  }
}