import 'package:crypto_app/utils/enums/app_theme_type.dart';
import 'package:crypto_app/utils/services/local_storage_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeType>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppThemeType> {
  ThemeNotifier() : super(AppThemeType.dark) {
    _loadTheme();
  }

  bool get isDark => state == AppThemeType.dark;

  Future<void> toggleTheme() async {
    state = isDark ? AppThemeType.light : AppThemeType.dark;
    await LocalStorageService.saveTheme(state.name);
  }

  Future<void> _loadTheme() async {
    final saved =  LocalStorageService.getTheme();
    state = saved == 'light' ? AppThemeType.light : AppThemeType.dark;
  }
}