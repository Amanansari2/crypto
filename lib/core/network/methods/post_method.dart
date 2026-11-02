import 'package:dio/dio.dart';

import '../dio_client.dart';

class PostMethod {
  final Dio _dio = DioClient().dio;



  Future<Response> postRequest({
    required String endpoint,
    dynamic data,
    bool requireAuth = false,
    Map<String, String>? customHeaders,
    bool isFormData = false,
  }) async {

    try {
      final headers = <String, String>{};


      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
            headers: headers,
          extra: {
            'requireAuth': requireAuth,
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return Exception("Connection timeout");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return Exception("Receive timeout");
    } else if (e.response != null) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        return Exception(data['message'].toString());
      }
      return Exception(
          "Server error: ${e.response?.statusCode} - ${e.response?.data}");
    } else {
      return Exception("Unexpected error");
    }
  }
}
