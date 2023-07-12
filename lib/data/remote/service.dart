import 'package:dio/dio.dart';
import 'package:stake_calculator/data/mapper/json_amount_mapper.dart';
import 'package:stake_calculator/data/mapper/json_reset_request_mapper.dart';
import 'package:stake_calculator/data/mapper/json_stake_mapper.dart';
import 'package:stake_calculator/data/mapper/json_stake_request_mapper.dart';
import 'package:stake_calculator/data/mapper/json_update_request_mapper.dart';
import 'package:stake_calculator/data/remote/model/create_stake_request.dart';
import 'package:stake_calculator/data/remote/model/reset_request.dart';
import 'package:stake_calculator/data/remote/model/stake_request.dart';
import 'package:stake_calculator/data/remote/model/update_request.dart';
import 'package:stake_calculator/domain/model/amount.dart';
import 'package:stake_calculator/domain/model/stake.dart';
import 'package:stake_calculator/domain/remote/IService.dart';

import '../mapper/json_create_stake_request_mapper.dart';
import '../mapper/json_licence_response_mapper.dart';
import '../model/api_response_state.dart';
import 'model/validate_licence_response.dart';

class Service extends IService {
  Dio client;

  Service({required this.client});

  @override
  Future<Amount> computeStake(StakeRequest request) async {
    try {
      final response = await client.post('/stake/compute',
          data: JsonStakeRequestMapper().to(request));
      return JsonAmountMapper().from(response.data['data']);
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
      final response = await client.get('/stake');
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
  Future<Stake> deleteTag({required String tagId}) async {
    try {
      final response = await client.delete('/stake/tag/$tagId');
      return JsonStakeMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }
}
