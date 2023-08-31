import 'dart:convert';

import 'package:stake_calculator/data/mapper/json_stake_mapper.dart';
import 'package:stake_calculator/data/mapper/odds_json_mapper.dart';
import 'package:stake_calculator/data/remote/model/bet_history_response.dart';
import 'package:stake_calculator/data/remote/model/create_stake_request.dart';
import 'package:stake_calculator/data/remote/model/reset_request.dart';
import 'package:stake_calculator/data/remote/model/stake_request.dart';
import 'package:stake_calculator/data/remote/model/update_request.dart';
import 'package:stake_calculator/domain/istake_repository.dart';
import 'package:stake_calculator/domain/model/stake.dart';
import 'package:stake_calculator/domain/remote/istake_service.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../domain/cache.dart';
import '../domain/model/bundle.dart';
import '../domain/model/odd.dart';

class StakeRepository extends IStakeRepository {
  IStakeService service;
  Cache cache;

  StakeRepository({required this.service, required this.cache});

  @override
  Future<Stake> computeStake({required List<Odd> odds, int? cycle}) async {
    final stake =
        JsonStakeMapper().from(jsonDecode(cache.getString(PREF_STAKE, '')));

    if (odds.length == 1) odds.clearPairs();

    return await service
        .computeStake(StakeRequest(odds: odds, cycle: stake.next))
        .then((value) {
      cache.set(PREF_STAKE, jsonEncode(JsonStakeMapper().to(value)));

      final tags = _getTags();
      tags.clearPairs();
      cache.set(PREF_TAGS_, jsonEncode(OddsJsonMapper().to(tags)));

      return value;
    });
  }

  @override
  Future<Stake> getStake({bool cached = false, bool tags = false}) async {
    if (cached) {
      final data = cache.getString(PREF_STAKE, '');
      if (data.isNotEmpty) {
        return JsonStakeMapper()
            .from(jsonDecode(cache.getString(PREF_STAKE, '')));
      }
    }
    return await service.getStake().then((value) async {
      cache.set(PREF_STAKE, jsonEncode(JsonStakeMapper().to(value)));
      if (tags && value.previousStake != null) {
        List<Odd> list = _getTags();
        if (list.isEmpty) {
          if (value.previousStake!.odds.isEmpty) {
            list.add(Odd(name: 'Default', odd: 0));
          } else {
            list.addAll(value.previousStake!.odds);
          }
          await cache.set(PREF_TAGS_, jsonEncode(OddsJsonMapper().to(list)));
        }
      }
      return value;
    });
  }

  @override
  Future<Stake> resetStake({bool won = false}) async {
    final losses = cache.getBool(PREF_CLEAR_LOSS, false);
    return await service
        .resetStake(ResetRequest(losses: losses, won: won))
        .then((value) {
      cache.set(PREF_STAKE, jsonEncode(JsonStakeMapper().to(value)));
      return value;
    });
  }

  @override
  Future<Stake> updateState(
      {double? profit,
      double? tolerance,
      required String mode,
      required bool decay,
      required bool isMultiple,
      required bool clearLosses,
      required bool approxAmount,
      required double startingStake,
      required bool keepTag,
      required bool forfeit,
      required int restrictRounds}) async {
    cache.set(PREF_CLEAR_LOSS, clearLosses);
    cache.set(PREF_KEEP_TAG, keepTag);

    return await service
        .updateState(UpdateRequest(
            profit: profit,
            approxAmount: approxAmount,
            tolerance: tolerance,
            decay: decay,
            mode: mode,
            forfeit: forfeit,
            restrictRounds: restrictRounds,
            startingStake: startingStake))
        .then((value) {
      cache.set(PREF_STAKE, jsonEncode(JsonStakeMapper().to(value)));
      cache.set(PREF_STAKE_TYPE, isMultiple);
      return value;
    });
  }

  @override
  Future<Stake> createSession(
      {required double profit, required double tolerance}) async {
    return await service
        .createSession(CreateStakeRequest(profit: profit, tolerance: tolerance))
        .then((value) {
      cache.set(PREF_SESSION_ID, value.id!);
      cache.set(PREF_STAKE, jsonEncode(JsonStakeMapper().to(value)));
      return value;
    });
  }

  @override
  Future<bool> getClearLoss() {
    return Future.value(cache.getBool(PREF_CLEAR_LOSS, false));
  }

  @override
  Future<void> saveClearLoss({required bool status}) async {
    await cache.set(PREF_CLEAR_LOSS, status);
  }

  @override
  Future<Stake> validateLicence(String licence) async {
    return await service.validateLicence(licence).then((value) {
      cache.set(PREF_AUTHORIZATION_, value.authorization!);
      return value.stake!;
    });
  }

  List<Odd> _getTags() {
    final data = cache.getString(PREF_TAGS_, '');
    return data.isNotEmpty ? OddsJsonMapper().from(jsonDecode(data)) : [];
  }

  @override
  Future<Stake> deleteTag({required int position, bool won = false}) async {
    List<Odd> tags = _getTags();
    final tag = tags.get(position);

    return await service
        .deleteTag(tagId: tag.tag ?? "", won: won)
        .then((value) {
      final keepTag = cache.getBool(PREF_KEEP_TAG, false);
      if (!keepTag) {
        tags.delete(position);
      }
      cache.set(PREF_STAKE, jsonEncode(JsonStakeMapper().to(value)));
      cache.set(PREF_TAGS_, jsonEncode(OddsJsonMapper().to(tags)));
      return value;
    });
  }

  @override
  Future<List<Odd>> getTags() async {
    return _getTags();
  }

  @override
  Future<List<Odd>> saveTag({required Odd odd}) async {
    List<Odd> odds = _getTags();
    odds.save(odd);

    await cache.set(PREF_TAGS_, jsonEncode(OddsJsonMapper().to(odds)));
    return odds;
  }

  @override
  Future<List<Odd>> updateTag({required Odd odd, required int position}) async {
    List<Odd> tags = _getTags();
    tags.update(odd, position);

    await cache.set(PREF_TAGS_, jsonEncode(OddsJsonMapper().to(tags)));
    return tags;
  }

  @override
  Future<void> saveGameType({required int type}) async {
    cache.set(PREF_GAME_TYPE, type);
  }

  @override
  int getGameType() {
    return cache.getInt(PREF_GAME_TYPE, 0);
  }

  @override
  Future<BetHistoryResponse> getHistory(
      {required int page, required int limit}) async {
    return await service.getHistory(page: page, limit: limit);
  }

  @override
  Future<List<Bundle>> getBundles() async {
    return await service.getBundles();
  }

  @override
  Future<bool> getKeepTag() async {
    return Future.value(cache.getBool(PREF_KEEP_TAG, false));
  }

  @override
  Future<bool> limitWarningShown() async {
    return Future.value(cache.getBool(PREF_LIMIT_WARNING, false));
  }

  @override
  Future<bool> streakWarningShown() async {
    return Future.value(cache.getBool(PREF_STREAK_WARNING, false));
  }

  @override
  bool getOnBoarding() => cache.getBool(PREF_ONBOARDED, false);

  @override
  Future<void> setOnBoarding({bool status = false}) async =>
      cache.set(PREF_ONBOARDED, status);

  @override
  bool getHomeTour() => cache.getBool(PREF_HOME_TOUR, false);

  @override
  bool getSettingTour() => cache.getBool(PREF_SETTING_TOUR, false);

  @override
  Future<void> setHomeTour({bool status = false}) =>
      cache.set(PREF_HOME_TOUR, status);

  @override
  Future<void> setSettingTour({bool status = false}) =>
      cache.set(PREF_SETTING_TOUR, status);
}
