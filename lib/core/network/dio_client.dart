import 'package:dio/dio.dart';

import '../utils/constants/api_urls.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/log_interceptor.dart';

class DioClient {
  static DioClient? _instance;

  late final Dio _dio;

  factory DioClient() {
    final instance = _instance;

    if (instance == null) {
      throw StateError(
        'DioClient has not been initialized',
      );
    }

    return instance;
  }

  DioClient._internal({
    required Future<String?> Function() tokenGetter,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptorCustom(),
      AuthInterceptor(
        tokenGetter: tokenGetter,
        dio: _dio,
      ),
    ]);
  }

  static void initialize({
    required Future<String?> Function() tokenGetter,
  }) {
    if (_instance != null) return;

    _instance = DioClient._internal(
      tokenGetter: tokenGetter,
    );
  }

  Dio get dio => _dio;

  void dispose() {
    _dio.close(force: true);
    _instance = null;
  }
}