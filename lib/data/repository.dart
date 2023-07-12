import 'dart:convert';

import 'package:stake_calculator/data/mapper/json_stake_mapper.dart';
import 'package:stake_calculator/data/mapper/odd_json_mapper.dart';
import 'package:stake_calculator/data/mapper/odds_json_mapper.dart';
import 'package:stake_calculator/data/remote/model/create_stake_request.dart';
import 'package:stake_calculator/data/remote/model/reset_request.dart';
import 'package:stake_calculator/data/remote/model/stake_request.dart';
import 'package:stake_calculator/data/remote/model/update_request.dart';
import 'package:stake_calculator/domain/irepository.dart';
import 'package:stake_calculator/domain/model/amount.dart';
import 'package:stake_calculator/domain/model/stake.dart';
import 'package:stake_calculator/domain/remote/IService.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../domain/cache.dart';
import '../domain/model/odd.dart';
import '../util/log.dart';

class Repository extends IRepository {
  IService service;
  Cache cache;

  Repository({required this.service, required this.cache});

  @override
  Future<Amount> computeStake({required List<Odd> odds, int? cycle}) async {
    final stake =
        JsonStakeMapper().from(jsonDecode(cache.getString(PREF_STAKE, '')));
    return await service
        .computeStake(StakeRequest(odds: odds, cycle: stake.next));
  }

  @override
  Future<Stake> getStake({bool cached = false}) async {
    if (cached) {
      return JsonStakeMapper()
          .from(jsonDecode(cache.getString(PREF_STAKE, '')));
    }
    return await service.getStake().then((value) {
      cache.set(PREF_STAKE, jsonEncode(JsonStakeMapper().to(value)));
      return value;
    });
  }

  @override
  Future<Stake> resetStake() async {
    final losses = cache.getBool(PREF_CLEAR_LOSS, false);
    return await service.resetStake(ResetRequest(losses: losses)).then((value) {
      cache.set(PREF_STAKE, jsonEncode(JsonStakeMapper().to(value)));
      return value;
    });
  }

  @override
  Future<Stake> updateState(
      {double? profit,
      double? tolerance,
      required bool decay,
      required bool isMultiple,
      required bool clearLosses,
      required double startingStake,
      required bool forfeit,
      required int restrictRounds}) async {
    cache.set(PREF_CLEAR_LOSS, clearLosses);

    return await service
        .updateState(UpdateRequest(
            profit: profit,
            tolerance: tolerance,
            decay: decay,
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

  Future<List<Odd>> _getTags() async {
    final data = cache.getString(PREF_TAGS_, '');
    return data.isNotEmpty ? OddsJsonMapper().from(jsonDecode(data)) : [];
  }

  @override
  Future<Stake> deleteTag({required int position}) async {
    List<Odd> tags = await _getTags();
    final tag = tags.get(position);

    return await service.deleteTag(tagId: tag.tag ?? "").then((value) {
      tags.delete(position);
      cache.set(PREF_STAKE, jsonEncode(JsonStakeMapper().to(value)));
      cache.set(PREF_TAGS_, jsonEncode(OddsJsonMapper().to(tags)));
      return value;
    });
  }

  @override
  Future<List<Odd>> getTags() async {
    return await _getTags();
  }

  @override
  Future<List<Odd>> saveTag({required Odd odd}) async {
    List<Odd> odds = await _getTags();
    odds.save(odd);

    await cache.set(PREF_TAGS_, jsonEncode(OddsJsonMapper().to(odds)));
    return odds;
  }

  @override
  Future<List<Odd>> updateTag({required Odd odd, required int position}) async {
    List<Odd> tags = await _getTags();
    tags.update(odd, position);

    await cache.set(PREF_TAGS_, jsonEncode(OddsJsonMapper().to(tags)));
    return tags;
  }
}
