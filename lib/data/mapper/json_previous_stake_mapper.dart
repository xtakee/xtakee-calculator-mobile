import 'package:stake_calculator/util/mapper.dart';

import '../../domain/model/previous_stake.dart';

class JsonPreviousStakeMapper
    extends Mapper<Map<String, dynamic>, PreviousStake> {
  @override
  PreviousStake from(Map<String, dynamic> from) => PreviousStake(
      value: from['value'] * 1.0, odd: from['odd'] * 1.0, id: from['_id']);

  @override
  Map<String, dynamic> to(PreviousStake from) {
    final map = <String, dynamic>{};
    map['odd'] = from.odd;
    map['value'] = from.value;
    map['_id'] = from.id;
    return map;
  }
}
