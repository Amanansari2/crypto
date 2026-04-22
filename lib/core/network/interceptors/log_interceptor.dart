import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:dio/dio.dart';

class LogInterceptorCustom extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogHelper.api(
      '${options.method} → ${options.uri} | headers: ${options.headers} | body: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogHelper.api(
      'RESPONSE [${response.statusCode}] → ${response.requestOptions.uri} | data: ${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    LogHelper.error(
      'API Error [${e.response?.statusCode ?? 0}] → ${e.requestOptions.uri}',
      error: e,
      stackTrace: StackTrace.current,
    );
    super.onError(e, handler);
  }
}
