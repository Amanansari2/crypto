import 'package:crypto_tutorial_app/providers/app_provider.dart';
import 'package:crypto_tutorial_app/providers/theme/theme_provider.dart';
import 'package:crypto_tutorial_app/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'providers/crypto_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await LocalStorageService.init();

  runApp(MultiProvider(
      providers: [
        ...AppProvider.providers
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, });

  @override
  Widget build(BuildContext context) {

    final themeMode = context.select<ThemeProvider, ThemeMode>(
          (p) => p.themeMode,
    );
    return MaterialApp(
      title: 'Crypto Watch',
      darkTheme: buildDarkTheme(),
      theme: buildLightTheme(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: Banner(
        message: 'FlexZ',
        location: BannerLocation.topEnd,
        color: Colors.deepPurpleAccent,
        child: const SplashScreen(),
      ),
    );
  }
}
