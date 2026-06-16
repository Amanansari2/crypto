import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/indicators/roc/roc_data_provider.dart';
import '../../../providers/indicators/roc/roc_provider.dart';
import '../../../providers/viewport_provider.dart';
import 'roc_painter.dart';

class RocWidget extends ConsumerWidget {

  const RocWidget({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final rocData =
    ref.watch(rocDataProvider);

    final viewport =
    ref.watch(viewportProvider);

    final settings =
    ref.watch(rocProvider);

    return SizedBox.expand(
      child: CustomPaint(
        painter: RocPainter(
          rocData: rocData,
          viewport: viewport,
          settings: settings,
        ),
      ),
    );
  }
}