import 'package:logger/logger.dart';

import 'config.dart';

class Log {
  static final _logger = Logger(printer: PrettyPrinter());

  static void d(dynamic message) {
    if (Config.shared.flavor == Flavor.development) {
      _logger.d(message);
    }
  }

  static void i(dynamic message) {
    if (Config.shared.flavor == Flavor.development) {
      _logger.i(message);
    }
  }

  static void e(dynamic message) {
    if (Config.shared.flavor == Flavor.development) {
      _logger.e(message);
    }
  }
}
