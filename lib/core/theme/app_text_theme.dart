import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme textTheme = TextTheme(
    /// DISPLAY (hero / big headings)
    displayLarge: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),

    /// HEADLINES
    headlineLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),

    /// TITLES
    titleLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),

    /// BODY
    bodyLarge: TextStyle(fontSize: 14.sp, height: 1.5),
    bodyMedium: TextStyle(fontSize: 12.sp, height: 1.4),
    bodySmall: TextStyle(fontSize: 11.sp, height: 1.3),

    /// LABEL (buttons, tabs)
    labelLarge: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    labelMedium: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
  );
}
