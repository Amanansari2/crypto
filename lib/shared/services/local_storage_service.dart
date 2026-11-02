import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {


  final SharedPreferences prefs;

  LocalStorageService(this.prefs);

  static const String _themeKey = "themeMode";
  static const String _onboardingKey = "onboarding_seen";
  static const String _closeAllConfirmationKey = "close_all_confirmation_skipped";
  static const String _cancelOrderConfirmationKey = "cancel_order_confirmation_skipped";
  static const String _logoutConfirmationKey = "logout_confirmation_skipped";

  static const String _tokenKey = "auth_token";
  static const String _userKey = "user";

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

  //<<----------------[ Close All Confirmation ]----------------->>

  Future<void> setCloseAllConfirmationSkipped() async {
    await prefs.setBool(
      _closeAllConfirmationKey,
      true,
    );
  }

  bool isCloseAllConfirmationSkipped() {
    return prefs.getBool(
      _closeAllConfirmationKey,
    ) ??
        false;
  }

  Future<void> setNeverShowLogoutConfirmation(bool value) async {
    await prefs.setBool(_logoutConfirmationKey, value);
  }

  bool getNeverShowLogoutConfirmation() {
    return prefs.getBool(_logoutConfirmationKey) ?? false;
  }


  //<<----------------[ Cancel Order Confirmation ]----------------->>

  Future<void> setCancelOrderConfirmationSkipped() async {
    await prefs.setBool(
      _cancelOrderConfirmationKey,
      true,
    );
  }

  bool isCancelOrderConfirmationSkipped() {
    return prefs.getBool(
      _cancelOrderConfirmationKey,
    ) ??
        false;
  }


  //<<----------------[ Authentication ]----------------->>

// Save JWT Token
  Future<void> saveToken(String token) async {
    await prefs.setString(_tokenKey, token);
  }

// Get JWT Token
  String? getToken() {
    return prefs.getString(_tokenKey);
  }

// Save User Data
  Future<void> saveUser(Map<String, dynamic> user) async {
    await prefs.setString(
      _userKey,
      jsonEncode(user),
    );
  }

// Get User Data
  Map<String, dynamic>? getUser() {
    final userData = prefs.getString(_userKey);

    if (userData == null) return null;

    return Map<String, dynamic>.from(
      jsonDecode(userData),
    );
  }

// Save Complete Auth Data
  Future<void> saveAuthData({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    await saveToken(token);
    await saveUser(user);
  }

// Clear Auth Data (Logout)
  Future<void> clearAuthData() async {
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }



}
