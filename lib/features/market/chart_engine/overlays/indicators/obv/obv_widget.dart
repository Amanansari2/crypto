import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/indicators/obv/obv_data_provider.dart';
import '../../../providers/indicators/obv/obv_provider.dart';
import '../../../providers/viewport_provider.dart';
import 'obv_painter.dart';

class ObvWidget extends ConsumerWidget {

  const ObvWidget({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final obvData =
    ref.watch(obvDataProvider);

    final viewport =
    ref.watch(viewportProvider);

    final settings =
    ref.watch(obvProvider);

    return SizedBox.expand(
      child: CustomPaint(
        painter: ObvPainter(
          obvData: obvData,
          viewport: viewport,
          settings: settings,
        ),
      ),
    );
  }
}