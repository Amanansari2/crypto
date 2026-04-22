import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class LogHelper {
  /// 🔹 Basic log
  static void log(String message, {String tag = 'LOG'}) {
    if (!kDebugMode) return;
    debugPrint("[$tag] $message");
  }

  /// 🔹 Success log
  static void success(String message, {String tag = 'SUCCESS'}) {
    if (!kDebugMode) return;
    debugPrint("✅ [$tag] $message");
  }

  /// 🔹 Warning log
  static void warning(String message, {String tag = 'WARNING'}) {
    if (!kDebugMode) return;
    debugPrint("⚠️ [$tag] $message");
  }

  /// 🔹 Error log (important)
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String tag = 'ERROR',
  }) {
    if (!kDebugMode) return;

    developer.log(message, name: tag, error: error, stackTrace: stackTrace);
  }

  /// 🔹 API log (simple version)
  static void api(String message) {
    if (!kDebugMode) return;
    debugPrint("🌐 [API] $message");
  }
}
