
import 'package:stake_calculator/data/remote/model/create_stake_request.dart';
import 'package:stake_calculator/data/remote/model/reset_request.dart';
import 'package:stake_calculator/data/remote/model/update_request.dart';

import '../../data/remote/model/stake_request.dart';
import '../../data/remote/model/validate_licence_response.dart';
import '../model/amount.dart';
import '../model/stake.dart';

abstract class IService {
  Future<Stake> getStake();
  Future<Stake> deleteTag({required String tagId});
  Future<Stake> createSession(CreateStakeRequest request);
  Future<Amount> computeStake(StakeRequest request);
  Future<Stake> updateState(UpdateRequest request);
  Future<Stake> resetStake(ResetRequest request);
  Future<ValidateLicenceResponse> validateLicence(String licence);
}