import 'package:flutter/material.dart';

class StochRsiSettingsModel {

  final int rsiLength;

  final int stochLength;

  final int smoothK;

  final int smoothD;

  final bool showK;

  final bool showD;

  final Color kColor;

  final Color dColor;

  const StochRsiSettingsModel({
    required this.rsiLength,
    required this.stochLength,
    required this.smoothK,
    required this.smoothD,
    required this.showK,
    required this.showD,
    required this.kColor,
    required this.dColor,
  });

  StochRsiSettingsModel copyWith({
    int? rsiLength,
    int? stochLength,
    int? smoothK,
    int? smoothD,
    bool? showK,
    bool? showD,
    Color? kColor,
    Color? dColor,
  }) {

    return StochRsiSettingsModel(
      rsiLength:
      rsiLength ?? this.rsiLength,

      stochLength:
      stochLength ?? this.stochLength,

      smoothK:
      smoothK ?? this.smoothK,

      smoothD:
      smoothD ?? this.smoothD,

      showK:
      showK ?? this.showK,

      showD:
      showD ?? this.showD,

      kColor:
      kColor ?? this.kColor,

      dColor:
      dColor ?? this.dColor,
    );
  }
}