import 'package:crypto_app/shared/providers/app_provider.dart';
import 'package:crypto_app/shared/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/network/dio_client.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localStorage = LocalStorageService(prefs);

  DioClient.initialize(
    tokenGetter: () async => localStorage.getToken(),
  );
  runApp(
      ProviderScope(
          overrides: [
            sharedPrefsProvider.overrideWithValue(prefs),
            localStorageProvider.overrideWithValue(localStorage),
          ],
          child: const MyApp()
      )
  );
}

