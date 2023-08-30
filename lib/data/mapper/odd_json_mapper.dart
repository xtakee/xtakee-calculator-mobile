import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/util/mapper.dart';

class OddJsonMapper extends Mapper<Map<String, dynamic>, Odd> {
  @override
  Odd from(Map<String, dynamic> from) => Odd(
      odd: from['odd'],
      tag: from['tag'],
      name: from['name'],
      won: from['won'],
      id: from['_id'],
      isPair: from['isPair']);

  @override
  Map<String, dynamic> to(Odd from) {
    final map = <String, dynamic>{};
    map['odd'] = from.odd;
    map['name'] = from.name;
    map['tag'] = from.tag;
    map['won'] = from.won;
    map['_id'] = from.id;
    map['isPair'] = from.isPair;
    return map;
  }
}
