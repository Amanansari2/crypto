import 'package:crypto_app/onboarding_view.dart';
import 'package:crypto_app/providers/theme_provider.dart';
import 'package:crypto_app/utils/enums/app_theme_type.dart';
import 'package:crypto_app/utils/services/local_storage_service.dart';
import 'package:crypto_app/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: theme == AppThemeType.dark ? ThemeMode.dark : ThemeMode.light,
      home: Banner(
          message: 'Crypto',
          location: BannerLocation.topStart,
          child: OnboardingView(),
      )
    );
    }
}


