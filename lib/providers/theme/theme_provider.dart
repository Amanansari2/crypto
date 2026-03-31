import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/local_storage_service.dart';


class ThemeProvider extends ChangeNotifier{

  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(){
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode{
    if(_themeMode == ThemeMode.system){
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  Future<void> setTheme(ThemeMode mode)async {
    _themeMode = mode;
    notifyListeners();
    await LocalStorageService.saveTheme(mode);
  }

  Future<void> toggleTheme() async{
    if(_themeMode == ThemeMode.light){
      await setTheme(ThemeMode.dark);
    }else if(_themeMode == ThemeMode.dark){
      await setTheme(ThemeMode.light);
    }else{
      final systemDark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
      await setTheme(systemDark ? ThemeMode.light : ThemeMode.dark);
    }
  }

  Future<void> _loadTheme() async {
    _themeMode = await LocalStorageService.getTheme();
    notifyListeners();
  }

}