import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../domain/cache.dart';

final logger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true,
    compact: false);

const String baseUrlDebug = "http://192.168.176.123:2021/v1";
const String baseUrlRemote = "https://api.staging.xtakee.com/v1";

_bearerAuthInterceptor(Cache cache) =>
    QueuedInterceptorsWrapper(onRequest: (options, interceptorHandler) async {
      String token = cache.getString(PREF_AUTHORIZATION_, "");

      options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      options.headers['Authorization'] = 'Bearer $token';
      return interceptorHandler.next(options);
    });

Dio dioClient(Cache cache) {
  Dio dio = Dio(BaseOptions(baseUrl: baseUrlRemote));

  dio.interceptors.add(logger);
  dio.interceptors.add(_bearerAuthInterceptor(cache));
  return dio;
}
