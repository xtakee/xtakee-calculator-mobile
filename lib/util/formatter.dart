import 'package:money_formatter/money_formatter.dart';

class Formatter {
  static final _setting = MoneyFormatterSettings(
      symbol: '#',
      thousandSeparator: ',',
      decimalSeparator: '.',
      symbolAndNumberSeparator: '',
      fractionDigits: 0,
      compactFormatType: CompactFormatType.short);

  static String format(double money, {String symbol = '#', int decimals = 2}) {
    _setting.symbol = symbol;
    _setting.fractionDigits = decimals;

    return MoneyFormatter(amount: money, settings: _setting)
        .output
        .symbolOnLeft;
  }
}
