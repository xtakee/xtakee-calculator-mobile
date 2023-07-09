import 'package:stake_calculator/util/mapper.dart';

import '../../domain/model/amount.dart';

class JsonAmountMapper extends Mapper<Map<String, dynamic>, Amount> {
  @override
  Amount from(Map<String, dynamic> from) => Amount(
      cycle: from['cycle'],
      next: from['next'],
      odd: from['odd'],
      totalStake: from['totalStake'],
      lot: from['lot'],
      expectedWin: from['expectedWin'],
      stake: from['stake']);

  @override
  Map<String, dynamic> to(Amount from) {
    final map = <String, dynamic>{};
    map["cycle"] = from.cycle;
    map["stake"] = from.stake;
    map['odd'] = from.odd;
    map['totalStake'] = from.totalStake;
    map['lot'] = from.lot;
    map['expectedWin'] = from.expectedWin;
    return map;
  }
}
