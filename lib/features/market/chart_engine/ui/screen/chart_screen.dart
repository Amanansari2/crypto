import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/candle_provider.dart';
import '../widgets/chart_canvas.dart';

class CustomChartScreen extends ConsumerWidget {
  const CustomChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candlesAsync = ref.watch(candleProvider);

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: candlesAsync.when(
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },

          error: (e, _) {
            return Center(
              child: Text(
                e.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          },

          data: (candles) {
            return SizedBox.expand(child: ChartCanvas(candles: candles));
          },
        ),
      ),
    );
  }
}
