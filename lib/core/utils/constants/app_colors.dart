import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// 🔥 BRAND (purple vibe like your UI)
  static const primary = Color(0xFF111F33);
  static const secondary = Color(0xFF16273F);

  static const blue = Color(0xFF223A5E);


  /// 🌙 DARK THEME
  static const darkBg = Color(0xFF0B0E1A);
  static const darkSurface = Color(0xFF14182A);
  static const darkCard = Color(0xFF1A1F35);

  /// ☀️ LIGHT THEME
  static const lightBg = Color(0xFFF5F7FB);
  static const lightSurface = Colors.white;
  static const lightCard = Colors.white;

  /// 🧾 TEXT (optional helpers)
  static const white = Colors.white;
  static const black = Colors.black;

  /// 💹 MARKET COLORS
  static const green = Color(0xFF16C784);
  static const red = Color(0xFFEA3943);

  /// ✨ GLOW / GRADIENT
  static const primaryGradient = LinearGradient(
    colors: [
      Color(0xFF7B61FF),
      Color(0xFF5B4DFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient navGradient = LinearGradient(
    colors: [
      Color(0xFF7B61FF),
      Color(0x4D7B61FF),
      Colors.transparent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}