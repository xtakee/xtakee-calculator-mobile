import 'model/amount.dart';
import 'model/odd.dart';
import 'model/stake.dart';

abstract class IRepository {
  Future<Stake> getStake({bool cached = false});

  Future<Stake> createSession(
      {required double profit, required double tolerance});

  Future<Amount> computeStake({required List<Odd> odds, required int cycle});

  Future<Stake> updateState(
      {double? profit,
      double? tolerance,
      required double startingStake,
      required bool decay,
      required bool clearLosses,
      required bool forfeit,
      required bool isMultiple,
      required int restrictRounds});

  Future<Stake> resetStake();

  Future<Stake> validateLicence(String licence);

  Future<bool> getClearLoss();

  Future<List<Odd>> saveTag({required Odd odd});

  Future<Stake> deleteTag({required int position});

  Future<List<Odd>> updateTag({required Odd odd, required int position});

  Future<List<Odd>> getTags();

  Future<void> saveClearLoss({required bool status});
}
