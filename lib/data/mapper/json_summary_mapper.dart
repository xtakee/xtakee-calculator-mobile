import 'package:stake_calculator/util/mapper.dart';

import '../../domain/model/summary.dart';

class JsonSummaryMapper extends Mapper<Map<String, dynamic>, Summary> {
  @override
  Summary from(Map<String, dynamic> from) => Summary(
      stakes: from['stakes'],
      wins: from['wins'],
      losses: from['losses'],
      coins: from['coins']);

  @override
  Map<String, dynamic> to(Summary from) {
    final map = <String, dynamic>{};
    map['stakes'] = from.stakes;
    map['coins'] = from.coins;
    map['wins'] = from.wins;
    map['losses'] = from.losses;
    return map;
  }
}
