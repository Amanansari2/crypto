import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/indicators/stoch/stoch_rsi_data_provider.dart';
import '../../../providers/indicators/stoch/stoch_rsi_provider.dart';
import '../../../providers/viewport_provider.dart';
import 'stoch_rsi_painter.dart';

class StochRsiWidget extends ConsumerWidget {

  const StochRsiWidget({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final data =
    ref.watch(
      stochRsiDataProvider,
    );

    final viewport =
    ref.watch(
      viewportProvider,
    );

    final settings =
    ref.watch(
      stochRsiProvider,
    );

    return SizedBox.expand(
      child: CustomPaint(
        painter: StochRsiPainter(
          data: data,
          viewport: viewport,
          settings: settings,
        ),
      ),
    );
  }
}