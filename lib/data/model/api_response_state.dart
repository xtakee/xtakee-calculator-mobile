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
          var message = data.message ?? "";
          if (message.contains("401") || message.contains("404")) {
            return NotFound();
          } else if (message.contains("402")) {
            return Forbidden(
                message: "Insufficient balance. Kindly buy more coins");
          } else if (message.contains("500")) {
            return UnKnown();
          } else {
            return NetworkError();
          }
        default:
          return NetworkError();
      }
    } else {
      return NetworkError();
    }
  }
}

abstract class ApiException implements Exception {
  final String message;

  ApiException({required this.message});

  @override
  String toString() => message;
}

class NotFound extends ApiException {
  NotFound({super.message = "No valid resource found for request"});
}

class UnKnown extends ApiException {
  UnKnown({super.message = "An unknown error occurred. Kindly try again"});
}

class Forbidden extends ApiException {
  Forbidden({required super.message});
}

class NetworkError extends ApiException {
  NetworkError({super.message = "Internet connection error"});
}
