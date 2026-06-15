import 'package:flutter/material.dart';

class WrSettingsModel {

  final int period;

  final Color color;

  const WrSettingsModel({
    required this.period,
    required this.color,
  });

  WrSettingsModel copyWith({
    int? period,
    Color? color,
  }) {

    return WrSettingsModel(
      period:
      period ?? this.period,

      color:
      color ?? this.color,
    );
  }
}