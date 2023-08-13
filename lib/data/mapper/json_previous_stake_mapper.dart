import 'package:stake_calculator/data/mapper/odd_json_mapper.dart';
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/util/mapper.dart';

import '../../domain/model/previous_stake.dart';

class JsonPreviousStakeMapper
    extends Mapper<Map<String, dynamic>, PreviousStake> {
  @override
  PreviousStake from(Map<String, dynamic> from) => PreviousStake(
      value: from['value'] * 1.0,
      odd: from['odd'] * 1.0,
      id: from['_id'],
      odds: from['odds'] != null
          ? List<Odd>.from(from['odds'].map((e) => OddJsonMapper().from(e)))
          : [],
      lot: from['lot'] * 1.0,
      totalWin: (from['value'] * 1.0) * from['odd'] * 1.0);

  @override
  Map<String, dynamic> to(PreviousStake from) {
    final map = <String, dynamic>{};
    map['odd'] = from.odd;
    map['value'] = from.value;
    map['_id'] = from.id;
    map['odds'] = from.odds.map((e) => OddJsonMapper().to(e)).toList();
    map['lot'] = from.lot;
    map['totalWin'] = from.totalWin;
    return map;
  }
}
