
import 'package:crypto_app/config/url.dart';
import 'package:crypto_app/utils/helpers/logger_helper.dart';
import 'package:dio/dio.dart';


class DioClient{
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient(){
    return _instance;
  }


  DioClient._internal(){
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
      )
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async{
         

          LogHelper.logRequest(
            method: options.method,
            url: options.uri.toString(),
            headers: options.headers,
           
          );
          return handler.next(options);
        },
        onResponse: (response, handler)async{
          LogHelper.logResponse(
            statusCode: response.statusCode ?? 0,
            url: response.requestOptions.uri.toString(),
            data: response.data,
          );
          return handler.next(response);
        },
        onError:(e, handler) async{
          LogHelper.logApiError(
            url: e.requestOptions.uri.toString(),
            error: e.error.toString(),
            statusCode: e.response?.statusCode ?? 0,
          );

          //-->>logout logic



         //---------------------------------------------------------------------------------//
          if(_shouldRetry(e)){
            LogHelper.logApiError(
              url: e.requestOptions.uri.toString(),
              error: e.error.toString(),
              statusCode: e.response?.statusCode ?? 0,
            );
          }
           handler.next(e);
        }
      )
    );
  }

  Dio get dio => _dio;

  bool _shouldRetry(DioError e){
    const maxRetries = 3;
    final retryCount = e.requestOptions.extra["retry_count"] ?? 0 ;
    final retryAble = e.type == DioErrorType.connectionTimeout ||
    e.type == DioErrorType.sendTimeout ||
    e.type == DioErrorType.receiveTimeout ||
    e.type == DioErrorType.unknown;

    return retryAble && retryCount < maxRetries;
  }

  void dispose(){
    _dio.close(force: true);
  }

}