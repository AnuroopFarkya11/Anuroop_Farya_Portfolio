import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/logger/logger.dart';
import 'package:my_portfolio/core/service/api_service/interceptors/log_interceptor.dart';
import 'api_response.dart';
import 'interceptors/auth_interceptor.dart';

final dioClientProvider = Provider((ref) {
  final Dio dio = Dio();
  return DioClient(dio: dio);
});

class DioClient {
  final Dio _dio;
  final _logger = Logger("DioClient");

  DioClient({required Dio dio}) : _dio = dio {

    // _dio.options.baseUrl = 'http://192.168.29.101:8080';
    // _dio.options.baseUrl = 'http://15.206.195.96:8080';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // _dio.options.headers = {
    //   'Content-Type': 'application/json',
    // };

    _dio.interceptors.addAll([
      LoggingInterceptor(),
    ]);
  }

  Future<ApiResponse<T>> get<T>(String endPoint,
      {Map<String, dynamic>? queryParameter}) async {
    return await _sendRequest<T>(
        () => _dio.get(endPoint, queryParameters: queryParameter));
  }

  Future<ApiResponse<T>> post<T>(String endPoint, {dynamic data}) async {
    return await _sendRequest<T>(() => _dio.post(endPoint, data: data));
  }

  Future<ApiResponse<T>> put<T>(String endPoint, {dynamic data}) async {
    return await _sendRequest<T>(() => _dio.put(endPoint, data: data));
  }

  Future<ApiResponse<T>> delete<T>(String endPoint, {dynamic data}) async {
    return await _sendRequest<T>(() => _dio.delete(endPoint, data: data));
  }

  Future<ApiResponse<T>> patch<T>(String endPoint, {dynamic data}) async {
    return await _sendRequest<T>(() => _dio.patch(endPoint, data: data));
  }

  Future<ApiResponse<T>> _sendRequest<T>(
      Future<Response> Function() request) async {
    try {
      final response = await request();
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return ApiResponse<T>(errorMessage: _handleError(e));
    }
  }

  ApiResponse<T> _handleResponse<T>(Response response) {
    switch (response.statusCode) {
      case 200:
        return ApiResponse<T>(data: response.data);
      case 400:
        return ApiResponse<T>(errorMessage: 'Bad request: ${response.data}');
      case 401:
        return ApiResponse<T>(errorMessage: 'Unauthorized access');
      case 404:
        return ApiResponse<T>(errorMessage: 'Not found');
      case 500:
      default:
        return ApiResponse<T>(
            errorMessage: 'Server error: ${response.statusCode}');
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection Timeout Exception";

      case DioExceptionType.sendTimeout:
        _logger.log("Send Timeout Exception");
        return "Send Timeout Exception";
      case DioExceptionType.receiveTimeout:
        _logger.log("Receive Timeout Exception");
        return "Receive Timeout Exception";
      case DioExceptionType.badResponse:
        _logger
            .log("Received invalid status code: ${error.response?.statusCode}");
        return "Received invalid status code: ${error.response?.statusCode}";
      case DioExceptionType.cancel:
        _logger.log("Request was cancelled");
        return "Request was cancelled";

      default:
        _logger.log("Unexpected error: ${error.message}");
        return"Unexpected error: ${error.message}";
    }
  }

  String _basicAuth() {
    String username = '8305048867';
    String password = 'Ram';

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    return basicAuth;
  }

  void useBasicAuth(String username, String password) {
    // _dio.interceptors.clear();
    _dio.interceptors.remove(AuthInterceptor);
    _dio.interceptors.add(AuthInterceptor.basicAuth(username, password));
  }

  void useBearerToken(String token) {
    _dio.interceptors.clear();
    _dio.interceptors.add(AuthInterceptor.token(token));
  }
}
