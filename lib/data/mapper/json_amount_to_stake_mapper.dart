import 'package:stake_calculator/data/remote/model/amount_to_stake.dart';
import 'package:stake_calculator/util/mapper.dart';

class JsonAmountToStakeMapper
    extends Mapper<Map<String, dynamic>, AmountToStake> {
  @override
  AmountToStake from(Map<String, dynamic> from) => AmountToStake(
      amount: from['amount'],
      odd: from['odd'],
      tag: from['tag'],
      expectedWin: from['expectedWin']);

  @override
  Map<String, dynamic> to(AmountToStake from) {
    final map = <String, dynamic>{};
    map['amount'] = from.amount;
    map['odd'] = from.odd;
    map['tag'] = from.tag;
    map['expectedWin'] = from.expectedWin;
    return map;
  }
}
