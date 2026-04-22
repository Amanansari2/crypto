import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // static late SharedPreferences _prefs;

  // static Future<void> init() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }

  final SharedPreferences prefs;

  LocalStorageService(this.prefs);

  static const String _themeKey = "themeMode";
  static const String _onboardingKey = "onboarding_seen";

  // static const String _tokenKey = "auth_token";

  //<<----------------[ Theme ]----------------->>

  /// Save theme
  Future<void> saveTheme(String theme) async {
    await prefs.setString(_themeKey, theme);
  }

  /// Get theme
  String getTheme() {
    return prefs.getString(_themeKey) ?? "dark";
  }

  //<<----------------[ OnBoarding ]----------------->>

  Future<void> setOnboardingSeen() async {
    await prefs.setBool(_onboardingKey, true);
  }

  bool isOnboardingSeen() {
    return prefs.getBool(_onboardingKey) ?? false;
  }
}
