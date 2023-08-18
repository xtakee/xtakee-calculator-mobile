import 'package:stake_calculator/data/remote/model/auth_response.dart';

import '../model/account.dart';
import '../model/summary.dart';

abstract class IAccountService {
  Future<AuthResponse> login({required Map<String, dynamic> data});

  Future<Summary> getSummary();

  Future<Account> getAccount();

  Future<String> sendOtp({required Map<String, dynamic> data});

  Future<void> resetPassword({required Map<String, dynamic> data});

  Future<AuthResponse> register({required Map<String, dynamic> data});

  Future<bool> changePassword({required Map<String, dynamic> data});
}