import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static const String _themeKey = "themeMode";
  static const String _onboardingKey = "onboarding_seen";
  static const String _tokenKey = "auth_token";

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //<<----------------[ Theme ]----------------->>

  /// Save theme
  static Future<void> saveTheme(String theme) async {
    await _prefs.setString(_themeKey, theme);
  }

  /// Get theme
  static String getTheme() {
    return _prefs.getString(_themeKey) ?? "dark";
  }

  //<<----------------[ OnBoarding ]----------------->>

  static Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  static bool isOnboardingSeen() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }
}