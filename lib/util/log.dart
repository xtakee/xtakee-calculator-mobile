
import 'package:logger/logger.dart';

class Log {
  static final _logger = Logger(
    printer: PrettyPrinter()
  );

  static void d(dynamic message) {
    _logger.d(message);
  }

  static void i(dynamic message) {
   _logger.i(message);
  }

  static void e(dynamic message) {
    _logger.e(message);
  }
}