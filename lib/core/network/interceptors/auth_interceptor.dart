import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final int maxRetries = 3;

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) async {
    final requestOptions = e.requestOptions;

    int retryCount = requestOptions.extra["retry_count"] ?? 0;

    if (_shouldRetry(e, retryCount)) {
      requestOptions.extra["retry_count"] = retryCount + 1;

      LogHelper.error(
        'API Retry ${retryCount + 1} → ${requestOptions.uri}',
        error: e,
      );

      final dio = Dio();
      final response = await dio.fetch(requestOptions);
      return handler.resolve(response);
    }

    /// future: logout / token refresh
    /// <-- yaha tera auth flow ayega

    return handler.next(e);
  }

  bool _shouldRetry(DioException e, int retryCount) {
    final retryAble =
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.unknown;

    return retryAble && retryCount < maxRetries;
  }
}
