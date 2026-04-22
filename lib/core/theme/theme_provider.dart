import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:crypto_app/shared/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/enums/app_theme_type.dart';

final themeProvider =
NotifierProvider<ThemeNotifier, AppThemeType>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<AppThemeType> {

  @override
  AppThemeType build() {
    final storage = ref.read(localStorageProvider);
    try {
      final saved = storage.getTheme();

      if (saved == null || saved.isEmpty) {
        return AppThemeType.system;
      }

      return AppThemeType.values.firstWhere(
              (e) => e.name == saved,
          orElse: () => AppThemeType.system
      );
    } catch (e, stackTrace) {
      LogHelper.error('Theme load failed', error: e, stackTrace: stackTrace);
      return AppThemeType.system;
    }
  }

  ThemeMode get themeMode =>
      switch(state){
        AppThemeType.light => ThemeMode.light,
        AppThemeType.dark => ThemeMode.dark,
        AppThemeType.system => ThemeMode.system
      };

  bool isDarkMode(Brightness platformBrightness) {
    return switch(state){
      AppThemeType.dark => true,
      AppThemeType.light => false,
      AppThemeType.system => platformBrightness == Brightness.dark
    };
  }

  bool get isSystem => state == AppThemeType.system;

  Future<void> setTheme(AppThemeType theme) async {
    if (state == theme) return;
    final storage = ref.read(localStorageProvider);
    state = theme;
    try {
      await storage.saveTheme(theme.name);
      LogHelper.log('Theme updated → $theme', tag: 'THEME');
    } catch (e, stackTrace) {
      LogHelper.error('Theme save failed', error: e, stackTrace: stackTrace);
    }
  }


  Future<void> toggleTheme() async {
    final next = switch (state) {
      AppThemeType.system => AppThemeType.dark,
      AppThemeType.dark => AppThemeType.light,
      AppThemeType.light => AppThemeType.dark,
    };
    await setTheme(next);
  }

  Future<void> resetToSystem() async {
    await setTheme(AppThemeType.system);
  }
}