import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      // Handle unauthorized error, e.g., redirect to login
    } else if (response.statusCode == 500) {
      // Handle server errors
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized error
    } else if (err.response?.statusCode == 500) {
      // Handle server errors
    }
    super.onError(err, handler);
  }
}
