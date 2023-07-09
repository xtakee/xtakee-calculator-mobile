import 'package:dio/dio.dart';

class ApiErrorHandler {
  static ApiException parse(data) {
    if (data is DioException) {
      switch (data.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkError();
        case DioExceptionType.badResponse:
          return NotFound();
        default:
          return NotFound();
      }
    } else {
      return NetworkError();
    }
  }
}

abstract class ApiException implements Exception {}

class NotFound extends ApiException {}

class UnKnown extends ApiException {}

class Forbidden extends ApiException {}

class NetworkError extends ApiException {}