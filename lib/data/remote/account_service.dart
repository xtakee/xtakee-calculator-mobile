import 'package:dio/dio.dart';
import 'package:stake_calculator/data/mapper/json_auth_response_mapper.dart';
import 'package:stake_calculator/data/mapper/json_summary_mapper.dart';
import 'package:stake_calculator/data/remote/model/auth_response.dart';
import 'package:stake_calculator/domain/model/summary.dart';
import 'package:stake_calculator/domain/remote/iaccount_service.dart';

import '../../domain/model/account.dart';
import '../mapper/json_account_mapper.dart';
import '../model/api_response_state.dart';

class AccountService extends IAccountService {
  Dio client;

  AccountService({required this.client});

  @override
  Future<bool> changePassword({required Map<String, dynamic> data}) async {
    try {
      await client.post('/account/change-password', data: data);
      return true;
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<AuthResponse> login({required Map<String, dynamic> data}) async {
    try {
      final response = await client.post('/account/login', data: data);
      return JsonAuthResponseMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<AuthResponse> register({required Map<String, dynamic> data}) async {
    try {
      final response = await client.post('/account', data: data);
      return JsonAuthResponseMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<Summary> getSummary() async {
    try {
      final response = await client.get('/account/summary');
      return JsonSummaryMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<Account> getAccount() async {
    try {
      final response = await client.get('/account/authorized');
      return JsonAccountMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<void> resetPassword({required Map<String, dynamic> data}) async {
    try {
      await client.post('/account/reset-password', data: data);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<String> sendOtp({required Map<String, dynamic> data}) async {
    try {
      final response = await client.post('/account/send-reset-otp', data: data);
      return response.data['data']['signature'];
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }
}
