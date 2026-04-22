// import 'package:dio/dio.dart';
//
// import '../dio_client.dart';
//
// class GetMethod{
//
//   final Dio _dio = DioClient().dio;
//
//   Future<Map<String, dynamic>> getRequest({
//     required String endpoint,
//     Map<String, dynamic>? queryParams,
//     bool requireAuth = false,
//     Map<String, String>? customHeaders
// }) async {
//     try{
//
//   final headers = <String, String>{};
//
//       if(requireAuth){
//         // final token = await LocalStorageService.getToken();
//         // if(token != null && token.isNotEmpty){
//         //   headers["Authorization"] = "Bearer $token";
//         // }
//       }
//       if(customHeaders != null){
//         headers.addAll(customHeaders);
//       }
//
//       final response = await _dio.get(
//         endpoint,
//         queryParameters: queryParams,
//         options: Options(headers: headers)
//       );
//
//       return response.data as Map<String, dynamic>;
//     }on DioError catch(e){
//       return{
//         'status' : 'error',
//         'code' : e.response?.statusCode ?? 500,
//         'message' : e.message,
//         'raw' : e.response?.data
//       };
//     }catch(e){
//       return {
//         'status' : 'error',
//         'code' : 500,
//         'message' : e.toString()
//       };
//     }
//   }
// }

//-------------------------

import 'package:dio/dio.dart';

import '../dio_client.dart';

class GetMethod {
  final Dio _dio = DioClient().dio;

  Future<Response> getRequest({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    bool requireAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final headers = <String, String>{};

      if (requireAuth) {
        // future: token logic
      }

      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers),
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
      return Exception("Server error: ${e.response?.statusCode}");
    } else {
      return Exception("Unexpected error");
    }
  }
}
