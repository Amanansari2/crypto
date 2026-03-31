import 'package:crypto_tutorial_app/providers/crypto_provider.dart';
import 'package:crypto_tutorial_app/providers/theme/theme_provider.dart';
import 'package:crypto_tutorial_app/screens/navbar/provider/nav_provider.dart';
import 'package:provider/provider.dart';

class AppProvider {

  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider()),

    ChangeNotifierProvider<NavProvider>(
        create: (_) => NavProvider()),

    ChangeNotifierProvider<CryptoProvider>(
        create: (_) => CryptoProvider())
  ];
}