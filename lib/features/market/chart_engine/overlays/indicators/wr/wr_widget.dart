import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/indicators/wr/wr_data_provider.dart';
import '../../../providers/indicators/wr/wr_provider.dart';
import '../../../providers/viewport_provider.dart';
import 'wr_painter.dart';

class WrWidget extends ConsumerWidget {

  const WrWidget({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final wrData =
    ref.watch(wrDataProvider);

    final viewport =
    ref.watch(viewportProvider);

    final settings =
    ref.watch(wrProvider);

    return SizedBox.expand(
      child: CustomPaint(
        painter: WrPainter(
          wrData: wrData,
          viewport: viewport,
          settings: settings,
        ),
      ),
    );
  }
}