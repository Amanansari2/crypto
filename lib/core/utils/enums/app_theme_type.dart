import 'package:flutter/material.dart';

enum AppThemeType {
  light,
  dark,
  system;

  String get label {
    switch (this) {
      case AppThemeType.light:
        return "Light";
      case AppThemeType.dark:
        return "Dark";
      case AppThemeType.system:
        return "System";
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeType.light:
        return Icons.light_mode;
      case AppThemeType.dark:
        return Icons.dark_mode;
      case AppThemeType.system:
        return Icons.settings;
    }
  }
}
