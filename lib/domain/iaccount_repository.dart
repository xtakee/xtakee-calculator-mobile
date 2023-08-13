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

  Future<Summary> getSummary();

  Future<bool> changePassword(
      {required String password, required String newPassword});
}
