import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderBookStepProvider =
NotifierProvider<
    OrderBookStepNotifier,
    double>(
  OrderBookStepNotifier.new,
);

class OrderBookStepNotifier
    extends Notifier<double> {

  @override
  double build() {
    return 0.1;
  }

  void changeStep(
      double step,
      ) {
    state = step;
  }
}