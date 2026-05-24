import 'package:flutter_riverpod/flutter_riverpod.dart';

final chartWidthProvider =
NotifierProvider<
    ChartWidthNotifier,
    double
>(

  ChartWidthNotifier.new,
);

class ChartWidthNotifier
    extends Notifier<double> {

  @override
  double build() {
    return 0;
  }

  void update(
      double width,
      ) {

    state = width;
  }
}