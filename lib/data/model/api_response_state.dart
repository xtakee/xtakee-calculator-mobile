import 'package:dio/dio.dart';

class ApiErrorHandler {
  static ApiException parse(data) {
    if (data is DioException) {
      String? error;
      if (data.response != null) {
        try {
          error = data.response!.data['data']['errors'][0]['message'];
        } catch (_) {}
      }
      switch (data.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkError();
        case DioExceptionType.badResponse:
          var message = data.message ?? "";
          if (message.contains("401")) {
            return UnAuthorized();
          } else if (message.contains("401") || message.contains("404")) {
            return NotFound();
          } else if (message.contains("402")) {
            return Forbidden(
                message: "Insufficient balance. Kindly buy more coins");
          } else if (message.contains("500")) {
            return UnKnown();
          } else if (message.contains("400")) {
            return BadRequest(message: error ?? "");
          } else {
            return UnKnown();
          }
        default:
          return UnKnown();
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

class UnAuthorized extends ApiException {
  UnAuthorized({super.message = "UnAuthorized"});
}

class NotFound extends ApiException {
  NotFound({super.message = "No valid resource found for request"});
}

class BadRequest extends ApiException {
  BadRequest({super.message = "Error processing your request"});
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
