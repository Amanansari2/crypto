import 'package:flutter/material.dart';

class ObvSettingsModel {

  final int maPeriod;

  final bool showObv;

  final bool showMaObv;

  final Color obvColor;

  final Color maObvColor;

  const ObvSettingsModel({
    required this.maPeriod,
    required this.showObv,
    required this.showMaObv,
    required this.obvColor,
    required this.maObvColor,
  });

  ObvSettingsModel copyWith({
    int? maPeriod,
    bool? showObv,
    bool? showMaObv,
    Color? obvColor,
    Color? maObvColor,
  }) {

    return ObvSettingsModel(
      maPeriod:
      maPeriod ?? this.maPeriod,

      showObv:
      showObv ?? this.showObv,

      showMaObv:
      showMaObv ?? this.showMaObv,

      obvColor:
      obvColor ?? this.obvColor,

      maObvColor:
      maObvColor ?? this.maObvColor,
    );
  }
}