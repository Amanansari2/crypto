import 'package:flutter/material.dart';

Widget card(
    {double width = double.infinity,
      double padding = 20,
       Color? color,
       double? radius,
       BoxBorder? border,
      required Widget child}) {
  return Container(
    width: width,
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
        color: color ?? Colors.white,
        border: border,
        borderRadius: BorderRadius.circular(radius ?? 15)),
    child: child,
  );
}