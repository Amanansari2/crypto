import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';

class AnimatedWrapper extends StatelessWidget {
  const AnimatedWrapper({
    super.key,
    required this.child,
    required this.index,
    this.delayPerItem = 150,
    this.duration = 400,
  });

  final Widget child;
  final int index;
  final int delayPerItem;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
        from: 30,
        duration: Duration(milliseconds: duration),
        delay: Duration(milliseconds: delayPerItem * index),
        child: child);
  }
}