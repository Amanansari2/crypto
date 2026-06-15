import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/indicators/kdj/kdj_data_provider.dart';
import '../../../providers/indicators/kdj/kdj_provider.dart';
import '../../../providers/viewport_provider.dart';
import 'kdj_painter.dart';

class KdjWidget extends ConsumerWidget {

  const KdjWidget({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final kdjData =
    ref.watch(
      kdjDataProvider,
    );

    final viewport =
    ref.watch(
      viewportProvider,
    );

    final settings =
    ref.watch(
      kdjProvider,
    );

    return SizedBox.expand(
      child: CustomPaint(
        painter: KdjPainter(
          kdjData: kdjData,
          viewport: viewport,
          settings: settings,
        ),
      ),
    );
  }
}