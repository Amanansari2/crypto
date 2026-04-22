import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/local_storage_service.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

/// Local Storage Service
final localStorageProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return LocalStorageService(prefs);
});
