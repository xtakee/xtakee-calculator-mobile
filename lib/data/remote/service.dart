import 'package:dio/dio.dart';
import 'package:stake_calculator/data/mapper/json_account_mapper.dart';
import 'package:stake_calculator/data/mapper/json_bet_history_response_mapper.dart';
import 'package:stake_calculator/data/mapper/json_bundle_mapper.dart';
import 'package:stake_calculator/data/mapper/json_reset_request_mapper.dart';
import 'package:stake_calculator/data/mapper/json_stake_mapper.dart';
import 'package:stake_calculator/data/mapper/json_stake_request_mapper.dart';
import 'package:stake_calculator/data/mapper/json_update_request_mapper.dart';
import 'package:stake_calculator/data/remote/model/bet_history_response.dart';
import 'package:stake_calculator/data/remote/model/create_stake_request.dart';
import 'package:stake_calculator/data/remote/model/reset_request.dart';
import 'package:stake_calculator/data/remote/model/stake_request.dart';
import 'package:stake_calculator/data/remote/model/update_request.dart';
import 'package:stake_calculator/domain/model/account.dart';
import 'package:stake_calculator/domain/model/bundle.dart';
import 'package:stake_calculator/domain/model/stake.dart';
import 'package:stake_calculator/domain/remote/iservice.dart';
import 'package:stake_calculator/util/log.dart';

import '../mapper/json_create_stake_request_mapper.dart';
import '../mapper/json_licence_response_mapper.dart';
import '../model/api_response_state.dart';
import 'model/validate_licence_response.dart';

class Service extends IService {
  Dio client;

  Service({required this.client});

  @override
  Future<Stake> computeStake(StakeRequest request) async {
    try {
      final response = await client.post('/stake/compute',
          data: JsonStakeRequestMapper().to(request));
      return JsonStakeMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<Stake> createSession(CreateStakeRequest request) async {
    try {
      final response = await client.post('/stake/create',
          data: JsonCreateStakeRequestMapper().to(request));
      return JsonStakeMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<Stake> getStake() async {
    try {
      final response = await client.get('/stake/me');
      return JsonStakeMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<Stake> resetStake(ResetRequest request) async {
    try {
      final response = await client.post('/stake/reset',
          data: JsonResetRequestMapper().to(request));
      return JsonStakeMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<Stake> updateState(UpdateRequest request) async {
    try {
      final response = await client.patch('/stake',
          data: JsonUpdateRequestMapper().to(request));
      return JsonStakeMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<ValidateLicenceResponse> validateLicence(String licence) async {
    try {
      final data = <String, dynamic>{};
      data['licence'] = licence;

      final response = await client.post('/licence/validate', data: data);
      return JsonLicenceResponseMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<Stake> deleteTag({required String tagId, required bool won}) async {
    try {
      final data = <String, dynamic>{};
      data['tag'] = tagId;
      data['won'] = won;
      final response = await client.delete('/stake/tag', data: data);
      return JsonStakeMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<BetHistoryResponse> getHistory(
      {required int page, required int limit}) async {
    try {
      final response =
          await client.get('/stake/history?limit=$limit&page=$page');
      return JsonBetHistoryResponseMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<List<Bundle>> getBundles() async {
    try {
      final response = await client.get('/bundle?type=bundle');
      return List<Bundle>.from(
          response.data['data'].map((e) => JsonBundleMapper().from(e)));
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }
}
