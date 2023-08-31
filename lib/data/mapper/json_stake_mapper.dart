import 'package:stake_calculator/domain/model/previous_stake.dart';
import 'package:stake_calculator/domain/model/stake.dart';
import 'package:stake_calculator/util/mapper.dart';

import 'json_previous_stake_mapper.dart';

class JsonStakeMapper extends Mapper<Map<String, dynamic>, Stake> {
  @override
  Stake from(from) => Stake(
      previousStake: from['previousStake'] != null
          ? JsonPreviousStakeMapper().from(from['previousStake'])
          : null,
      losses: from['losses'] * 1.0,
      profit: from['profit'] * 1.0,
      cycle: from['cycle'],
      next: from['next'],
      wins: from['wins'],
      coins: from['coins'],
      stakes: from['stakes'],
      cumLosses: from['cumLosses'],
      isWiningStreak: from['isWiningStreak'],
      rounded: from['rounded'],
      tolerance: from['tolerance'] * 1.0,
      overflow: from['overflow'] * 1.0,
      decay: from['decay'],
      restrictRounds: from['restrictRounds'],
      startingStake: from['startingStake'] * 1.0,
      recoveryCycles: from['recoveryCycles'],
      cycleRecovered: from['cycleRecovered'],
      authRequired: from['authRequired'],
      forfeit: from['forfeit'],
      mode: from['mode'],
      forfeiture: from['forfeiture'],
      id: from['_id'],
      createdAt: from['createdAt'],
      updatedAt: from['updatedAt']);

  @override
  Map<String, dynamic> to(Stake from) {
    final map = <String, dynamic>{};
    if (from.previousStake != null) {
      map['previousStake'] = JsonPreviousStakeMapper().to(from.previousStake!);
    }
    map['losses'] = from.losses;
    map['profit'] = from.profit;
    map['cycle'] = from.cycle;
    map['next'] = from.next;
    map['coins'] = from.coins;
    map['cumLosses'] = from.cumLosses;
    map['stakes'] = from.stakes;
    map['wins'] = from.wins;
    map['mode'] = from.mode;
    map['rounded'] = from.rounded;
    map['startingStake'] = from.startingStake;
    map['tolerance'] = from.tolerance;
    map['overflow'] = from.overflow;
    map['recovery'] = from.recovery;
    map['recoveryCycles'] = from.recoveryCycles;
    map['cycleRecovered'] = from.cycleRecovered;
    map['authRequired'] = from.authRequired;
    map['forfeit'] = from.forfeit;
    map['decay'] = from.decay;
    map['restrictRounds'] = from.restrictRounds;
    map['forfeiture'] = from.forfeiture;
    map['forfeited'] = from.forfeited;
    map['_id'] = from.id;
    map['createdAt'] = from.createdAt;
    map['updatedAt'] = from.updatedAt;
    return map;
  }
}
