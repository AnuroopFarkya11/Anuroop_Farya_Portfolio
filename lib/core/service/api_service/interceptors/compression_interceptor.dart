import 'dart:convert';
import 'package:dio/dio.dart';

class CompressionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
   /* if (options.data != null && options.method == 'POST') {
      options.data = GzipCodec().encode(utf8.encode(options.data));
      options.headers['Content-Encoding'] = 'gzip';
    }*/
    super.onRequest(options, handler);
  }
}
