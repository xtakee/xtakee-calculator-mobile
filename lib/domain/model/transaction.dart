import 'package:stake_calculator/domain/model/account.dart';
import 'package:stake_calculator/domain/model/bundle.dart';

class Transaction {
  Transaction({
    String? channel,
    String? createdAt,
    String? updatedAt,
    String? auth,
    String? gateway,
    num? charge,
    String? status,
    String? id,
    Account? account,
    num? amount,
    Bundle? bundle,
    String? reference,
    String? description,
    String? message,
    String? type,
  }) {
    _channel = channel;
    _gateway = gateway;
    _charge = charge;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
    _auth = auth;
    _id = id;
    _account = account;
    _amount = amount;
    _bundle = bundle;
    _reference = reference;
    _description = description;
    _message = message;
    _type = type;
  }

  String? _channel;
  String? _gateway;
  String? _createdAt;
  String? _updatedAt;
  String? _auth;
  num? _charge;
  String? _status;
  String? _id;
  Account? _account;
  num? _amount;
  Bundle? _bundle;
  String? _reference;
  String? _description;
  String? _message;
  String? _type;

  String? get channel => _channel;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get gateway => _gateway;

  String? get auth => _auth;

  num? get charge => _charge;

  String? get status => _status;

  String? get id => _id;

  Account? get account => _account;

  num? get amount => _amount;

  Bundle? get bundle => _bundle;

  String? get reference => _reference;

  String? get description => _description;

  String? get message => _message;

  String? get type => _type;
}
