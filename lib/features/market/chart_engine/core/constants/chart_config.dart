class ChartConfig {
  ChartConfig._();

  /// 🔥 LAYOUT
  static const double chartPadding = 2;
  static const double chartRadius = 18;

  /// 🔥 AXIS
  static const double axisWidth = 40.0;
  static const double timeAxisHeight = 14;

  /// 🔥 ZOOM
  static const double minZoom = 5;

  static const double maxZoom = 25;

  /// 🔥 CROSSHAIR
  static const double crosshairWidth = 0.5;
  static const double crosshairSafePadding = 8;

  /// 🔥 LABELS
  static const double priceLabelHeight = 24;

  static const double timeLabelHeight = 20;
  static const double timeLabelWidth = 72.0;

  /// 🔥 GRID
  static const int horizontalGridCount = 2;

  static const int verticalGridCount = 2;

  /// 🔥 CHART
  static const double candleMinBody = 1.2;

  static const double candleMaxBody = 22;

  /// 🔥 SPACING
  static const double minSpacing = 0.8;

  static const double maxSpacing = 6;

  //Preload Count
  static const int preloadTriggerCount = 30;

  //extraVisible Candels
  static const int extraVisibleCandles = 2;
  static const int rightSideExtraCandles = 9;

  //marker width
  static const int markerWidth = 28;
}
