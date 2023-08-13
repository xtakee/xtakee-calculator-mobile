import 'package:stake_calculator/domain/model/account.dart';

class AuthResponse {
  Account? _account;
  String? _authorization;

  AuthResponse({Account? account, String? authorization}) {
    _authorization = authorization;
    _account = account;
  }

  Account? get account => _account;

  String? get authorization => _authorization;
}
