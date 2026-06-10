import 'dart:ui';

class VolumeSettingsModel {

  final bool enabled;

  final Color upColor;

  final Color downColor;

  final int ma1Period;
  final int ma2Period;

  final Color ma1Color;
  final Color ma2Color;

  final bool showMa1;
  final bool showMa2;

  const VolumeSettingsModel({
    this.enabled = true,
    required this.upColor,
    required this.downColor,
    required this.ma1Period,
    required this.ma2Period,

    required this.ma1Color,
    required this.ma2Color,

    this.showMa1 = true,
    this.showMa2 = true,
  });

  VolumeSettingsModel copyWith({
    bool? enabled,
    Color? upColor,
    Color? downColor,
    int? ma1Period,
    int? ma2Period,

    Color? ma1Color,
    Color? ma2Color,

    bool? showMa1,
    bool? showMa2,
  }) {
    return VolumeSettingsModel(
      enabled:
      enabled ?? this.enabled,
      upColor:
      upColor ?? this.upColor,
      downColor:
      downColor ?? this.downColor,
      ma1Period:
      ma1Period ?? this.ma1Period,

      ma2Period:
      ma2Period ?? this.ma2Period,

      ma1Color:
      ma1Color ?? this.ma1Color,

      ma2Color:
      ma2Color ?? this.ma2Color,

      showMa1:
      showMa1 ?? this.showMa1,

      showMa2:
      showMa2 ?? this.showMa2,
    );
  }
}