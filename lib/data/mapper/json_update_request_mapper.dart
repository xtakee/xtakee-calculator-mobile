import 'package:stake_calculator/data/remote/model/update_request.dart';
import 'package:stake_calculator/util/mapper.dart';

import '../../util/log.dart';

class JsonUpdateRequestMapper
    extends Mapper<Map<String, dynamic>, UpdateRequest> {
  @override
  UpdateRequest from(Map<String, dynamic> from) => UpdateRequest();

  @override
  Map<String, dynamic> to(UpdateRequest from) {
    final map = <String, dynamic>{};
    map['profit'] = from.profit;
    map['forfeit'] = from.forfeit;
    map['rounded'] = from.approxAmount;
    map['restrictRounds'] = from.restrictRounds;
    map['decay'] = from.decay;
    map['startingStake'] = from.startingStake;
    map['tolerance'] = from.tolerance;
    return map;
  }
}
