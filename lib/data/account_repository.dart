import 'dart:convert';

import 'package:stake_calculator/data/mapper/json_account_mapper.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';
import 'package:stake_calculator/domain/model/account.dart';
import 'package:stake_calculator/domain/model/phone.dart';
import 'package:stake_calculator/domain/model/summary.dart';
import 'package:stake_calculator/domain/remote/iaccount_service.dart';

import '../domain/cache.dart';

class AccountRepository extends IAccountRepository {
  final IAccountService service;
  final Cache cache;

  AccountRepository({required this.service, required this.cache});

  @override
  Future<bool> changePassword(
      {required String password, required String newPassword}) async {
    final data = <String, dynamic>{};
    data['newPassword'] = newPassword;
    data['oldPassword'] = password;
    return await service.changePassword(data: data);
  }

  @override
  Future<Account> login(
      {required String email, required String password}) async {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return await service.login(data: data).then((auth) {
      cache.set(
          PREF_ACCOUNT, jsonEncode(JsonAccountMapper().to(auth.account!)));
      cache.set(PREF_AUTHORIZATION_, auth.authorization ?? "");
      return auth.account!;
    });
  }

  @override
  Future<Account> register(
      {required String email,
      required String password,
      required String name,
      required Phone phone}) async {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['phone'] = {"code": "+234", "number": phone.number};
    data['country'] = {"code": "NG", "name": "Nigeria"};

    return await service.register(data: data).then((auth) {
      cache.set(
          PREF_ACCOUNT, jsonEncode(JsonAccountMapper().to(auth.account!)));
      cache.set(PREF_AUTHORIZATION_, auth.authorization ?? "");
      return auth.account!;
    });
  }

  @override
  Future<Account> getAccount() async {
    final data = cache.getString(PREF_ACCOUNT, '');
    if (data.isNotEmpty) {
      return JsonAccountMapper().from(jsonDecode(data));
    }
    return await service.getAccount().then((value) {
      cache.set(PREF_ACCOUNT, jsonEncode(JsonAccountMapper().to(value)));
      return value;
    });
  }

  @override
  Future<Summary> getSummary() async => await service.getSummary();
}
