import 'package:stake_calculator/util/mapper.dart';

import '../remote/model/reset_request.dart';

class JsonResetRequestMapper
    extends Mapper<Map<String, dynamic>, ResetRequest> {
  @override
  ResetRequest from(Map<String, dynamic> from) => ResetRequest();

  @override
  Map<String, dynamic> to(ResetRequest from) {
    final map = <String, dynamic>{};
    map['losses'] = from.losses;

    return map;
  }
}
