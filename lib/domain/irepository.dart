import 'package:stake_calculator/domain/model/bundle.dart';

import '../data/remote/model/bet_history_response.dart';
import 'model/odd.dart';
import 'model/stake.dart';
import 'model/transaction.dart';

abstract class IRepository {
  Future<Stake> getStake({bool cached = false});

  Future<Stake> createSession(
      {required double profit, required double tolerance});

  Future<Stake> computeStake({required List<Odd> odds, required int cycle});

  Future<Stake> updateState(
      {double? profit,
      double? tolerance,
      required double startingStake,
      required bool decay,
      required bool clearLosses,
      required bool forfeit,
      required bool keepTag,
      required bool isMultiple,
      required int restrictRounds});

  Future<Stake> resetStake({bool won = false});

  Future<bool> limitWarningShown();
  Future<bool> streakWarningShown();

  Future<Stake> validateLicence(String licence);

  Future<bool> getClearLoss();

  Future<bool> getKeepTag();

  Future<List<Odd>> saveTag({required Odd odd});

  Future<List<Bundle>> getBundles();

  Future<void> saveGameType({required int type});

  Future<BetHistoryResponse> getHistory(
      {required int page, required int limit});

  int getGameType();

  Future<Stake> deleteTag({required int position, bool won = false});

  Future<List<Odd>> updateTag({required Odd odd, required int position});

  Future<List<Odd>> getTags();

  Future<void> saveClearLoss({required bool status});
}
