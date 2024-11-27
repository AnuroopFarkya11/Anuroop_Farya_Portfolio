import 'package:dio/dio.dart';
import 'dart:async';

class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int _retries;
  final Duration _retryInterval;

  RetryInterceptor(this._dio,
      {int retries = 3, Duration retryInterval = const Duration(seconds: 2)})
      : _retries = retries,
        _retryInterval = retryInterval;

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        final response = await _retryRequest(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    // Define conditions to retry
    return err.type == DioExceptionType.unknown ||
        err.type == DioExceptionType.connectionTimeout;
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    int retryCount = 0;
    while (retryCount < _retries) {
      try {
        await Future.delayed(_retryInterval);
        return await _dio.request(
          requestOptions.path,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          ),
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );
      } catch (e) {
        retryCount++;
      }
    }
    throw DioError(
        requestOptions: requestOptions,
        error: 'Failed after retrying $_retries times');
  }
}
