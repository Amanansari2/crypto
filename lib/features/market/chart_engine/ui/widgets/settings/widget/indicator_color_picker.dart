import 'package:flutter/material.dart';

class IndicatorColorPicker
    extends StatelessWidget {

  final List<Color> colors;

  final ValueChanged<Color>
  onColorSelected;

  const IndicatorColorPicker({
    super.key,
    required this.colors,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {

    return Wrap(
      spacing: 18,
      runSpacing: 10,
      children: colors.map((color) {

        return InkWell(
          onTap: () {
            onColorSelected(color);
          },
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: color,
              borderRadius:
              BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }
}