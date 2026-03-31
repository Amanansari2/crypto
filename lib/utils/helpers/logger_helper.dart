import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class LogHelper {
  static const int chunkSize = 800;

  /// 🔹 Normal log
  static void log(String message, {String tag = 'LOG'}) {
    if (kDebugMode) {
      debugPrint("[$tag] $message");
    }
  }

  /// 🔹 API Request Log
static void logRequest({
  required String method,
  required String url,
  Map<String, dynamic>? headers,
  dynamic body,
}) {
  if (!kDebugMode) return;

  log("➡️ $method $url", tag: "API");

  if (headers != null) {
    logJson(headers, tag: "HEADERS");
  }

  if (body != null) {
    logJson(body, tag: "BODY");
  }
}

/// 🔹 API Response Log
static void logResponse({
  required int statusCode,
  required String url,
  dynamic data,
}) {
  if (!kDebugMode) return;

  log("✅ [$statusCode] $url", tag: "API_RESPONSE");

  if (data != null) {
    logJson(data, tag: "RESPONSE_BODY");
  }
}

/// 🔹 API Error Log
static void logApiError({
  required String url,
  String? error,
  int? statusCode,
}) {
  if (!kDebugMode) return;

  log("❌ [$statusCode] $url", tag: "API_ERROR");

  if (error != null) {
    log(error, tag: "ERROR_MESSAGE");
  }
}

  /// 🔹 Long log (auto split)
  static void logLong(String message, {String tag = 'LONG_LOG'}) {
    if (!kDebugMode) return;

    final pattern = RegExp('.{1,$chunkSize}');
    for (final match in pattern.allMatches(message)) {
      debugPrint("[$tag] ${match.group(0)}");
    }
  }

  /// 🔹 Pretty JSON log
  static void logJson(dynamic json, {String tag = 'JSON'}) {
    if (!kDebugMode) return;

    try {
      final pretty = _formatJson(json);
      logLong(pretty, tag: tag);
    } catch (e) {
      log("Invalid JSON: $json", tag: tag);
    }
  }

  /// 🔹 Error log
  static void logError(String message, {String tag = 'ERROR'}) {
    if (kDebugMode) {
      developer.log(message, name: tag, error: message);
    }
  }

  /// 🔹 Private JSON formatter
  static String _formatJson(dynamic json) {
    const indent = '  ';
    return _prettyPrint(json, 0, indent);
  }

  static String _prettyPrint(dynamic json, int level, String indent) {
    final space = indent * level;

    if (json is Map) {
      final buffer = StringBuffer('{\n');
      json.forEach((key, value) {
        buffer.write(
            '$space$indent"$key": ${_prettyPrint(value, level + 1, indent)},\n');
      });
      buffer.write('$space}');
      return buffer.toString();
    } else if (json is List) {
      final buffer = StringBuffer('[\n');
      for (var item in json) {
        buffer.write(
            '$space$indent${_prettyPrint(item, level + 1, indent)},\n');
      }
      buffer.write('$space]');
      return buffer.toString();
    } else if (json is String) {
      return '"$json"';
    } else {
      return json.toString();
    }
  }
}