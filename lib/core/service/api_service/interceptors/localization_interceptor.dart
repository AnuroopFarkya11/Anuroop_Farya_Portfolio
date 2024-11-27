import 'package:dio/dio.dart';

class LocalizationInterceptor extends Interceptor {
  final String _languageCode;

  LocalizationInterceptor(this._languageCode);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = _languageCode;
    super.onRequest(options, handler);
  }
}
