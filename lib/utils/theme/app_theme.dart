




import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2962FF),
      secondary: Color(0xFF00C853),
      surface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF0F1115),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2962FF),
      secondary: Color(0xFF00E676),
      surface: Color(0xFF1C1F26),
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
    ),
  );
}