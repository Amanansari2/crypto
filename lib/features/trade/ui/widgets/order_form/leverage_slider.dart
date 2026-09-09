import 'package:flutter/material.dart';

class LeverageSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const LeverageSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,

          onTapDown: (details) {
            final width = constraints.maxWidth;

            final dx =
            details.localPosition.dx.clamp(
              0.0,
              width,
            );

            final leverage = ((dx / width) * 149 + 1)
                .round();

            onChanged(leverage);
          },

          onHorizontalDragUpdate: (details) {
            final width = constraints.maxWidth;

            final dx =
            details.localPosition.dx.clamp(
              0.0,
              width,
            );

            final leverage = ((dx / width) * 149 + 1)
                .round();

            onChanged(leverage);
          },

          child: SizedBox(
            height: 55,
            child: CustomPaint(
              size: Size(
                constraints.maxWidth,
                55,
              ),
              painter: LeverageSliderPainter(
                leverage: value,
              ),
            ),
          ),
        );
      },
    );
  }

}

class LeverageSliderPainter extends CustomPainter {
  final int leverage;

  LeverageSliderPainter({
    required this.leverage,
  });

  static const List<int> points = [
    1,
    30,
    60,
    90,
    120,
    150,
  ];

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    const trackY = 12.0;

    final inactivePaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2;

    final activePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    final progress =
        (leverage - 1) / (150 - 1);

    final thumbX =
        progress * size.width;

    /// Track
    canvas.drawLine(
      Offset(0, trackY),
      Offset(size.width, trackY),
      inactivePaint,
    );

    /// Active Track
    canvas.drawLine(
      Offset(0, trackY),
      Offset(thumbX, trackY),
      activePaint,
    );

    /// Markers
    for (final point in points) {
      final p =
          (point - 1) / (150 - 1);

      final x = p * size.width;

      final selected =
          leverage >= point;

      final rect = Rect.fromCenter(
        center: Offset(x, trackY),
        width: 7,
        height: 7,
      );

      canvas.drawRect(
        rect,
        Paint()
          ..color = selected
              ? Colors.blue
              : Colors.white,
      );

      canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = Colors.blue,
      );

      final tp = TextPainter(
        text: TextSpan(
          text: '${point}X',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        textDirection:
        TextDirection.ltr,
      );

      tp.layout();

      tp.paint(
        canvas,
        Offset(
          x - tp.width / 2,
          32,
        ),
      );
    }

    /// Thumb
    canvas.drawCircle(
      Offset(thumbX, trackY),
      6,
      Paint()..color = Colors.blue,
    );

    canvas.drawCircle(
      Offset(thumbX, trackY),
      3,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(
      covariant LeverageSliderPainter oldDelegate,
      ) {
    return leverage !=
        oldDelegate.leverage;
  }
}
