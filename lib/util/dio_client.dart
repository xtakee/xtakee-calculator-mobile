import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:stake_calculator/util/config.dart';

import '../domain/cache.dart';

final logger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true,
    compact: false);

_bearerAuthInterceptor(Cache cache) =>
    QueuedInterceptorsWrapper(onRequest: (options, interceptorHandler) async {
      String token = cache.getString(PREF_AUTHORIZATION_, "");

      options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      options.headers['Authorization'] = 'Bearer $token';
      options.receiveTimeout = const Duration(seconds: 10);
      options.sendTimeout = const Duration(seconds: 10);
      return interceptorHandler.next(options);
    });

Dio dioClient(Cache cache) {
  Dio dio = Dio(BaseOptions(baseUrl: Config.shared.baseUrl));

  if(Config.shared.flavor == Flavor.development) {
    dio.interceptors.add(logger);
  }
  dio.interceptors.add(_bearerAuthInterceptor(cache));
  return dio;
}
