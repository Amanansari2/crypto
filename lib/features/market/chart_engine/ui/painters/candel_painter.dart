// import 'package:flutter/material.dart';
//
// import '../../../../../core/utils/constants/app_colors.dart';
// import '../../core/models/viewport_model.dart';
// import '../../core/models/candle_model.dart';
// import '../../providers/crosshair_provider.dart';
//
// class CandlePainter extends CustomPainter {
//
//   final List<CandleModel> candles;
//
//   final ChartViewport viewport;
//  final CrosshairState crosshair;
//
//   CandlePainter({
//     required this.candles,
//     required this.viewport,
//     required this.crosshair
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//
//     final bullPaint = Paint()
//       ..isAntiAlias = false
//       ..color = AppColors.green
//       ..strokeWidth = 1;
//
//     final bearPaint = Paint()
//       ..isAntiAlias = false
//       ..color = AppColors.red
//       ..strokeWidth = 1;
//
//     if (candles.isEmpty) return;
//
//     final startIndex =
//     (viewport.scrollX / viewport.candleWidth).floor();
//
//     final visibleCount =
//     (size.width / viewport.candleWidth).ceil();
//
//     final endIndex =
//         startIndex + visibleCount + 2;
//
//     final safeStart =
//     startIndex.clamp(0, candles.length);
//
//     final safeEnd =
//     endIndex.clamp(0, candles.length);
//
//     final visibleCandles =
//     candles.sublist(
//       safeStart,
//       safeEnd,
//     );
//     if (visibleCandles.isEmpty) {
//       return;
//     }
//     final maxPrice =
//     visibleCandles
//         .map((e) => e.high)
//         .reduce(
//           (a, b) =>
//       a > b ? a : b,
//     );
//
//     final minPrice =
//     visibleCandles
//         .map((e) => e.low)
//         .reduce(
//           (a, b) =>
//       a < b ? a : b,
//     );
//
//     final priceRange =
//     (maxPrice - minPrice)
//         .abs();
//
//     if (priceRange <= 0) {
//       return;
//     }
//
//     for (int i = safeStart; i < safeEnd; i++) {
//
//       final candle = candles[i];
//
//       final x =
//           (i * viewport.candleWidth) -
//               viewport.scrollX;
//
//       final openY =
//           size.height *
//               (1 -
//                   ((candle.open - minPrice) /
//                       priceRange));
//
//       final closeY =
//           size.height *
//               (1 -
//                   ((candle.close - minPrice) /
//                       priceRange));
//
//       final highY =
//           size.height *
//               (1 -
//                   ((candle.high - minPrice) /
//                       priceRange));
//
//       final lowY =
//           size.height *
//               (1 -
//                   ((candle.low - minPrice) /
//                       priceRange));
//
//       final isBull =
//           candle.close >= candle.open;
//
//       final paint =
//       isBull ? bullPaint : bearPaint;
//
//       /// wick
//       canvas.drawLine(
//         Offset(
//             x + viewport.candleWidth / 2,
//             highY),
//         Offset(
//             x + viewport.candleWidth / 2,
//             lowY),
//         paint,
//       );
//
//       /// body
//       canvas.drawRect(
//         Rect.fromLTRB(
//           x,
//           openY,
//           x + viewport.candleWidth,
//           closeY,
//         ),
//         paint,
//       );
//     }
//
//     if (
//     crosshair.visible &&
//         crosshair.position != null
//     ) {
//
//       final crossPaint = Paint()
//         ..isAntiAlias = false
//         ..color = Colors.white54
//         ..strokeWidth = 0.5;
//
//       /// vertical
//       canvas.drawLine(
//         Offset(
//           crosshair.position!.dx,
//           0,
//         ),
//
//         Offset(
//           crosshair.position!.dx,
//           size.height,
//         ),
//
//         crossPaint,
//       );
//
//       /// horizontal
//       canvas.drawLine(
//         Offset(
//           0,
//           crosshair.position!.dy,
//         ),
//
//         Offset(
//           size.width,
//           crosshair.position!.dy,
//         ),
//
//         crossPaint,
//       );
//     }
//
//   }
//
//   @override
//   bool shouldRepaint(
//       covariant CandlePainter old,
//       ) {
//
//     return old.viewport != viewport ||
//         old.crosshair != crosshair ||
//         old.candles != candles;
//   }
// }

import 'package:flutter/material.dart';

import '../../core/models/candle_model.dart';
import '../../core/models/viewport_model.dart';
import '../../providers/crosshair_provider.dart';

class CandlePainter extends CustomPainter {
  final List<CandleModel> candles;

  final ChartViewport viewport;

  final CrosshairState crosshair;

  CandlePainter({
    required this.candles,
    required this.viewport,
    required this.crosshair,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final bullPaint = Paint()
      ..isAntiAlias = false
      ..color = Colors.green
      ..strokeWidth = 1;

    final bearPaint = Paint()
      ..isAntiAlias = false
      ..color = Colors.red
      ..strokeWidth = 1;

    final crossPaint = Paint()
      ..isAntiAlias = false
      ..color = Colors.white54
      ..strokeWidth = 0.5;

    final startIndex = (viewport.scrollX / viewport.candleWidth).floor();

    final visibleCount = (size.width / viewport.candleWidth).ceil();

    final endIndex = startIndex + visibleCount + 2;

    final safeStart = startIndex.clamp(0, candles.length);

    final safeEnd = endIndex.clamp(0, candles.length);

    if (safeStart >= safeEnd) {
      return;
    }

    /// 🔥 FAST min/max calculation
    double maxPrice = double.negativeInfinity;

    double minPrice = double.infinity;

    for (int i = safeStart; i < safeEnd; i++) {
      final candle = candles[i];

      if (candle.high > maxPrice) {
        maxPrice = candle.high;
      }

      if (candle.low < minPrice) {
        minPrice = candle.low;
      }
    }

    final priceRange = (maxPrice - minPrice).abs();

    if (priceRange <= 0) {
      return;
    }

    /// 🔥 DRAW CANDLES
    for (int i = safeStart; i < safeEnd; i++) {
      final candle = candles[i];

      final x = (i * viewport.candleWidth) - viewport.scrollX;

      /// 🔥 skip offscreen left
      if (x + viewport.candleWidth < 0) {
        continue;
      }

      /// 🔥 stop offscreen right
      if (x > size.width) {
        break;
      }

      final openY = size.height * (1 - ((candle.open - minPrice) / priceRange));

      final closeY =
          size.height * (1 - ((candle.close - minPrice) / priceRange));

      final highY = size.height * (1 - ((candle.high - minPrice) / priceRange));

      final lowY = size.height * (1 - ((candle.low - minPrice) / priceRange));

      final isBull = candle.close >= candle.open;

      final paint = isBull ? bullPaint : bearPaint;

      /// 🔥 WICK
      canvas.drawLine(
        Offset(x + viewport.candleWidth / 2, highY),
        Offset(x + viewport.candleWidth / 2, lowY),
        paint,
      );

      /// 🔥 BODY SAFE DRAW
      final top = openY < closeY ? openY : closeY;

      final bottom = openY > closeY ? openY : closeY;

      canvas.drawRect(
        Rect.fromLTRB(
          x,
          top,
          x + viewport.candleWidth,
          bottom == top ? bottom + 1 : bottom,
        ),
        paint,
      );
    }

    /// 🔥 CROSSHAIR
    if (crosshair.visible && crosshair.position != null) {
      final pos = crosshair.position!;

      /// vertical
      canvas.drawLine(
        Offset(pos.dx, 0),
        Offset(pos.dx, size.height),
        crossPaint,
      );

      /// horizontal
      canvas.drawLine(
        Offset(0, pos.dy),
        Offset(size.width, pos.dy),
        crossPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CandlePainter old) {
    return old.viewport != viewport ||
        old.crosshair != crosshair ||
        old.candles != candles;
  }
}
