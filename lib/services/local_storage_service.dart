import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/enums/app_theme_type.dart';

class LocalStorageService{
  static late SharedPreferences _prefs;

  static const String _themeKey = "themeMode";
  static const String _favKey = "favorites";



  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }







  //________________________________Theme
//==> Save Theme
  static Future<void> saveTheme(ThemeMode themeMode) async {
    await _prefs.setInt(_themeKey, themeMode.index);
  }

//==> get Theme
  static ThemeMode getTheme()  {
    final index = _prefs.getInt(_themeKey);
    if(index != null ){
      return ThemeMode.values[index];
    }
    return ThemeMode.system;
  }


  static List<int> getFavorites() {
    final ids = _prefs.getStringList(_favKey) ?? [];
    return ids.map(int.parse).toList();
  }

  static Future<void> saveFavorites(List<int> ids) async {
    await _prefs.setStringList(
      _favKey,
      ids.map((e) => e.toString()).toList(),
    );
  }

}