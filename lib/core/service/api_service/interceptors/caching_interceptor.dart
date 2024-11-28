import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheInterceptor extends Interceptor {
  final CacheManager _cacheManager;

  CacheInterceptor(this._cacheManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['noCache'] != true) {
      final cachedResponse = await _cacheManager.getFileFromCache(options.uri.toString());
      if (cachedResponse != null) {
        handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: cachedResponse.file.readAsStringSync(),
          extra: options.extra,
        ));
        return;
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 200 && response.requestOptions.extra['noCache'] != true) {
      await _cacheManager.putFile(response.requestOptions.uri.toString(), response.data);
    }
    super.onResponse(response, handler);
  }
}
