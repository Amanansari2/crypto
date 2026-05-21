class GestureEngine {
  /// 🔥 calculate zoom
  static double calculateZoom({
    required double startZoom,

    required double scale,

    double minZoom = 3,

    double maxZoom = 28,
  }) {
    double newZoom = (startZoom * scale).clamp(minZoom, maxZoom);

    /// 🔥 smooth stable zoom
    newZoom = (newZoom * 10).round() / 10;

    return newZoom;
  }

  /// 🔥 calculate focal zoom scroll
  static double calculateZoomScroll({
    required double startScroll,

    required double startZoom,

    required double newZoom,

    required double focalX,
  }) {
    /// 🔥 freeze world position
    final worldX = startScroll + focalX;

    /// 🔥 keep same candle
    final newScroll = (worldX * (newZoom / startZoom)) - focalX;

    return newScroll;
  }

  /// 🔥 calculate pan
  static double calculatePan({
    required double currentScroll,

    required double deltaX,
  }) {
    return currentScroll - deltaX;
  }
}
