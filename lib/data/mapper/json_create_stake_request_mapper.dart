import 'package:stake_calculator/data/remote/model/create_stake_request.dart';
import 'package:stake_calculator/util/mapper.dart';

class JsonCreateStakeRequestMapper
    extends Mapper<Map<String, dynamic>, CreateStakeRequest> {
  @override
  CreateStakeRequest from(Map<String, dynamic> from) =>
      CreateStakeRequest();

  @override
  Map<String, dynamic> to(CreateStakeRequest from) {
    final map = <String, dynamic>{};
    map['profit'] = from.profit;
    map['tolerance'] = from.tolerance;
    return map;
  }
}
