import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/indicators/macd/macd_data_provider.dart';
import '../../../providers/indicators/macd/macd_provider.dart';
import '../../../providers/viewport_provider.dart';
import 'macd_painter.dart';

class MacdWidget extends ConsumerWidget {

  const MacdWidget({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final macdData =
    ref.watch(macdDataProvider);

    final viewport =
    ref.watch(viewportProvider);

    final settings =
    ref.watch(macdProvider);

    return SizedBox.expand(
      child: CustomPaint(
        painter: MacdPainter(
          macdData: macdData,
          viewport: viewport,
          settings: settings,
        ),
      ),
    );
  }
}