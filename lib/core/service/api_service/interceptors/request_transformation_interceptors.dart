import 'package:dio/dio.dart';

class ResponseTransformationInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map<String, dynamic>) {
      response.data = _transformResponse(response.data);
    }
    super.onResponse(response, handler);
  }

  Map<String, dynamic> _transformResponse(Map<String, dynamic> data) {

    return {
      'status': data['status'] ?? 'success',
      'data': data['data'] ?? {},
      'message': data['message'] ?? '',
    };
  }
}
