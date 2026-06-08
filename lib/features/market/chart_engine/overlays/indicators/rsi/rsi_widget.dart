import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/indicators/rsi/rsi_data_provider.dart';
import '../../../providers/indicators/rsi/rsi_provider.dart';
import '../../../providers/viewport_provider.dart';
import 'rsi_painter.dart';

class RsiWidget extends ConsumerWidget {
  const RsiWidget({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final rsiData =
    ref.watch(rsiDataProvider);

    final viewport =
    ref.watch(viewportProvider);

    final settings =
    ref.watch(rsiProvider);

    return SizedBox.expand(
      child: CustomPaint(
        painter: RsiPainter(
          rsiData: rsiData,
          viewport: viewport,
          settings: settings
        ),
      ),
    );
  }
}