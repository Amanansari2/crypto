import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() tokenGetter;
  final Dio dio;

  final int maxRetries = 3;

  AuthInterceptor({
    required this.tokenGetter,
    required this.dio,
  });

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      if (options.extra['requireAuth'] == true) {
        final token = await tokenGetter();

        if (token == null || token.trim().isEmpty) {
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.cancel,
              error: 'Authentication token is required',
            ),
          );
        }

        options.headers['Authorization'] = 'Bearer ${token.trim()}';
      }

      handler.next(options);
    } catch (error) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
        ),
      );
    }
  }

  @override
  void onError(
      DioException e,
      ErrorInterceptorHandler handler,
      ) async {
    final requestOptions = e.requestOptions;
    final retryCount = requestOptions.extra['retry_count'] ?? 0;

    final isGetRequest =
        requestOptions.method.toUpperCase() == 'GET';

    if (isGetRequest && _shouldRetry(e, retryCount)) {
      requestOptions.extra['retry_count'] = retryCount + 1;

      LogHelper.error(
        'API Retry ${retryCount + 1} → ${requestOptions.uri}',
        error: e,
      );

      try {
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } on DioException catch (retryError) {
        return handler.next(retryError);
      } catch (error) {
        return handler.next(e);
      }
    }

    handler.next(e);
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