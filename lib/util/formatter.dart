import 'package:money_formatter/money_formatter.dart';

class Formatter {
  static var _setting = MoneyFormatterSettings(
      symbol: '#',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolAndNumberSeparator: '',
      fractionDigits: 2,
      compactFormatType: CompactFormatType.short);

  static String format(double money, {String symbol = '#'}) {
    if (symbol != '#') {
      _setting = MoneyFormatterSettings(
          symbol: symbol,
          thousandSeparator: ',',
          decimalSeparator: '.',
          symbolAndNumberSeparator: '',
          fractionDigits: 2,
          compactFormatType: CompactFormatType.short);
    }
    return MoneyFormatter(amount: money, settings: _setting)
        .output
        .symbolOnLeft;
  }
}
