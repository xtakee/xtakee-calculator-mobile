import 'package:stake_calculator/data/remote/model/auth_response.dart';
import 'package:stake_calculator/domain/model/account.dart';
import 'package:stake_calculator/domain/model/phone.dart';
import 'package:stake_calculator/domain/model/summary.dart';

abstract class IAccountRepository {
  Future<Account> login({required String email, required String password});

  Future<Account> register(
      {required String email,
      required String password,
      required String name,
      required Phone phone});

  Future<Account> getAccount();

  Future<void> ackNotification({required String campaign});

  Future<void> resendOtp();

  Future<void> updatePushToken({required String token});

  Future<Summary> getSummary();

  Future<bool> sendOtp({required String email});

  Future<void> resetPassword({required String otp, required String password});

  Future<bool> changePassword(
      {required String password, required String newPassword});
}
