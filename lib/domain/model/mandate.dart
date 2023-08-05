import 'account.dart';

class Mandate {
  Mandate({
    String? merchant,
    String? id,
    Account? account,
    String? expiryMonth,
    String? gateway,
    String? expiryYear,
    String? cardType,
    bool? reusable,
    String? channel,
    String? brand,
    String? bank,
    String? bin,
    String? last4,
  }) {
    _merchant = merchant;
    _id = id;
    _account = account;
    _gateway = gateway;
    _expiryMonth = expiryMonth;
    _expiryYear = expiryYear;
    _cardType = cardType;
    _reusable = reusable;
    _channel = channel;
    _brand = brand;
    _bank = bank;
    _bin = bin;
    _last4 = last4;
  }

  String? _merchant;
  String? _id;
  String? _gateway;
  Account? _account;
  String? _expiryMonth;
  String? _expiryYear;
  String? _cardType;
  bool? _reusable;
  String? _channel;
  String? _brand;
  String? _bank;
  String? _bin;
  String? _last4;

  String? get merchant => _merchant;

  String? get id => _id;

  String? get gateway => _gateway;

  Account? get account => _account;

  String? get expiryMonth => _expiryMonth;

  String? get expiryYear => _expiryYear;

  String? get cardType => _cardType;

  bool? get reusable => _reusable;

  String? get channel => _channel;

  String? get brand => _brand;

  String? get bank => _bank;

  String? get bin => _bin;

  String? get last4 => _last4;
}
