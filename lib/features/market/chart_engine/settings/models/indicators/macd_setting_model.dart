import 'package:flutter/material.dart';

class MacdSettingsModel {

  final int fastPeriod;
  final int slowPeriod;
  final int signalPeriod;

  final Color macdColor;
  final Color signalColor;

  final Color positiveHistogramColor;
  final Color negativeHistogramColor;

  final bool enabled;
  final bool showMacdLine;
  final bool showSignalLine;

  const MacdSettingsModel({
    required this.fastPeriod,
    required this.slowPeriod,
    required this.signalPeriod,
    required this.macdColor,
    required this.signalColor,
    required this.positiveHistogramColor,
    required this.negativeHistogramColor,
    this.enabled = true,
    this.showMacdLine = true,
    this.showSignalLine = true,
  });

  MacdSettingsModel copyWith({
    int? fastPeriod,
    int? slowPeriod,
    int? signalPeriod,
    Color? macdColor,
    Color? signalColor,
    Color? positiveHistogramColor,
    Color? negativeHistogramColor,
    bool? enabled,
    bool? showMacdLine,
    bool? showSignalLine,
  }) {

    return MacdSettingsModel(
      fastPeriod:
      fastPeriod ?? this.fastPeriod,
      slowPeriod:
      slowPeriod ?? this.slowPeriod,
      signalPeriod:
      signalPeriod ?? this.signalPeriod,
      macdColor:
      macdColor ?? this.macdColor,
      signalColor:
      signalColor ?? this.signalColor,
      positiveHistogramColor:
      positiveHistogramColor ??
          this.positiveHistogramColor,
      negativeHistogramColor:
      negativeHistogramColor ??
          this.negativeHistogramColor,
      enabled:
      enabled ?? this.enabled,
      showMacdLine:
      showMacdLine ??
          this.showMacdLine,

      showSignalLine:
      showSignalLine ??
          this.showSignalLine,
    );
  }
}