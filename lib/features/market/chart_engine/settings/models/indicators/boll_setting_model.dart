import 'package:flutter/material.dart';

class BollSettingsModel {

  final int period;

  final double bandwidth;

  final Color upperColor;

  final Color middleColor;

  final Color lowerColor;

  final bool showUpper;

  final bool showMiddle;

  final bool showLower;

  const BollSettingsModel({
    required this.period,
    required this.bandwidth,
    required this.upperColor,
    required this.middleColor,
    required this.lowerColor,
    required this.showUpper,
    required this.showMiddle,
    required this.showLower,
  });

  BollSettingsModel copyWith({
    int? period,
    double? bandwidth,
    Color? upperColor,
    Color? middleColor,
    Color? lowerColor,
    bool? showUpper,
    bool? showMiddle,
    bool? showLower,
  }) {

    return BollSettingsModel(
      period: period ?? this.period,
      bandwidth: bandwidth ?? this.bandwidth,

      upperColor:
      upperColor ?? this.upperColor,

      middleColor:
      middleColor ?? this.middleColor,

      lowerColor:
      lowerColor ?? this.lowerColor,

      showUpper:
      showUpper ?? this.showUpper,

      showMiddle:
      showMiddle ?? this.showMiddle,

      showLower:
      showLower ?? this.showLower,
    );
  }
}