import 'package:flutter/cupertino.dart';

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  double get bottomInset => MediaQuery.of(this).padding.bottom;

  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  bool get isKeyboardVisible => keyboardHeight > 0;

  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
}
