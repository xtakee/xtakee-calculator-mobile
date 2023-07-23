import 'package:stake_calculator/util/mapper.dart';

import '../../domain/model/history.dart';
import '../../domain/model/odd.dart';
import 'odd_json_mapper.dart';

class JsonHistoryMapper extends Mapper<Map<String, dynamic>, History> {
  @override
  History from(Map<String, dynamic> from) => History(
      won: from['won'],
      amount: from['amount'],
      id: from['_id'],
      stake: from['stake'],
      round: from['round'],
      odds: from['odds'] != null
          ? List<Odd>.from(from['odds'].map((v) => OddJsonMapper().from(v)))
          : [],
      createdAt: from['createdAt'],
      updatedAt: from['updatedAt']);

  @override
  Map<String, dynamic> to(History from) {
    final map = <String, dynamic>{};
    map['won'] = from.won;
    map['amount'] = from.amount;
    map['round'] = from.round;
    map['_id'] = from.id;
    map['stake'] = from.stake;
    if (from.odds != null) {
      map['odds'] = from.odds?.map((v) => OddJsonMapper().to(v)).toList();
    }
    map['createdAt'] = from.createdAt;
    map['updatedAt'] = from.updatedAt;
    return map;
  }
}
