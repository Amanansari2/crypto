import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double animatedPositionedLEftValue(int currentIndex, BuildContext context) {
  int itemCount = 3;
  double totalWidth = MediaQuery.of(context).size.width - 32.w; // padding

  final itemWidth = totalWidth / itemCount;

  return (itemWidth * currentIndex) +
      (itemWidth / 2) -
      25.w; // indicator center adjust
}
