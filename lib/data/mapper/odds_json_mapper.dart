import 'package:stake_calculator/data/mapper/odd_json_mapper.dart';
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/util/mapper.dart';

class OddsJsonMapper extends Mapper<Map<String, dynamic>, List<Odd>> {
  @override
  List<Odd> from(Map<String, dynamic> from) =>
      List<Odd>.from(from['odds'].map((tag) => OddJsonMapper().from(tag)));

  @override
  Map<String, dynamic> to(List<Odd> from) {
    final map = <String, dynamic>{};
    map['odds'] =
        List<Map<String, dynamic>>.from(from.map((e) => OddJsonMapper().to(e)));
    return map;
  }
}
