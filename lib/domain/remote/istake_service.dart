import 'package:stake_calculator/data/remote/model/bet_history_response.dart';
import 'package:stake_calculator/data/remote/model/create_stake_request.dart';
import 'package:stake_calculator/data/remote/model/reset_request.dart';
import 'package:stake_calculator/data/remote/model/update_request.dart';

import '../../data/remote/model/stake_request.dart';
import '../../data/remote/model/validate_licence_response.dart';
import '../model/bundle.dart';
import '../model/stake.dart';

abstract class IStakeService {
  Future<Stake> getStake();

  Future<Stake> deleteTag({required String tagId, required bool won});

  Future<Stake> createSession(CreateStakeRequest request);

  Future<Stake> computeStake(StakeRequest request);

  Future<Stake> updateState(UpdateRequest request);

  Future<Stake> resetStake(ResetRequest request);

  Future<List<Bundle>> getBundles();

  Future<BetHistoryResponse> getHistory(
      {required int page, required int limit});

  Future<ValidateLicenceResponse> validateLicence(String licence);
}
