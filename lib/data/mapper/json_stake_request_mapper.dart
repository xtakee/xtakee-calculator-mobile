import 'package:stake_calculator/data/remote/model/stake_request.dart';
import 'package:stake_calculator/util/mapper.dart';

import 'odd_json_mapper.dart';

class JsonStakeRequestMapper
    extends Mapper<Map<String, dynamic>, StakeRequest> {
  @override
  StakeRequest from(Map<String, dynamic> from) => StakeRequest();

  @override
  Map<String, dynamic> to(StakeRequest from) {
    final map = <String, dynamic>{};
    map['odds'] = List<Map<String, dynamic>>.from(
        from.odds!.map((e) => OddJsonMapper().to(e)));
    map['cycle'] = from.cycle;
    return map;
  }
}
