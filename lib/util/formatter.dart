import 'package:money_formatter/money_formatter.dart';

class Formatter {
  static final _setting = MoneyFormatterSettings(
      symbol: '#',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolAndNumberSeparator: '',
      fractionDigits: 2,
      compactFormatType: CompactFormatType.short);

  static String format(double money) {
    return MoneyFormatter(amount: money, settings: _setting)
        .output
        .symbolOnLeft;
  }
}
