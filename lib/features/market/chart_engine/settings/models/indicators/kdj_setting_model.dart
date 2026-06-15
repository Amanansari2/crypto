import 'package:flutter/material.dart';

class KdjSettingsModel {

  final int period;

  final int ma1;

  final int ma2;

  final bool showK;

  final bool showD;

  final bool showJ;

  final Color kColor;

  final Color dColor;

  final Color jColor;

  const KdjSettingsModel({
    required this.period,
    required this.ma1,
    required this.ma2,
    required this.showK,
    required this.showD,
    required this.showJ,
    required this.kColor,
    required this.dColor,
    required this.jColor,
  });

  KdjSettingsModel copyWith({
    int? period,
    int? ma1,
    int? ma2,
    bool? showK,
    bool? showD,
    bool? showJ,
    Color? kColor,
    Color? dColor,
    Color? jColor,
  }) {

    return KdjSettingsModel(
      period:
      period ?? this.period,

      ma1:
      ma1 ?? this.ma1,

      ma2:
      ma2 ?? this.ma2,

      showK:
      showK ?? this.showK,

      showD:
      showD ?? this.showD,

      showJ:
      showJ ?? this.showJ,

      kColor:
      kColor ?? this.kColor,

      dColor:
      dColor ?? this.dColor,

      jColor:
      jColor ?? this.jColor,
    );
  }
}