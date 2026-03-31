import 'package:crypto_app/core/sample_widget.dart';
import 'package:crypto_app/utils/constants/size.config.dart';
import 'package:flutter/material.dart';

List<Widget> screens = [
  const SampleWidget(
    label: 'HOME',
    color: Colors.deepPurpleAccent,
  ),
  const SampleWidget(
    label: 'SEARCH',
    color: Colors.amber,
  ),
  const SampleWidget(
    label: 'EXPLORE',
    color: Colors.cyan,
  ),
 
];

double animatedPositionedLEftValue(int currentIndex, BuildContext context) {
  int itemCount = 3;
  double totalWidth =
      MediaQuery.of(context).size.width -
      (AppSizes.blockSizeHorizontal * 9); // padding

  double itemWidth = totalWidth / itemCount;


  return (AppSizes.blockSizeHorizontal * 4.5) + // left padding
      (itemWidth * currentIndex) +
      (itemWidth / 2) -
      (itemWidth / 2) + 18; // indicator center adjust
}

final List<Color> gradient = [
  Colors.yellow.withOpacity(0.8),
  Colors.yellow.withOpacity(0.5),
  Colors.transparent
];