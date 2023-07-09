import 'package:stake_calculator/data/mapper/json_stake_mapper.dart';
import 'package:stake_calculator/data/remote/model/validate_licence_response.dart';

import '../../util/mapper.dart';

class JsonLicenceResponseMapper
    extends Mapper<Map<String, dynamic>, ValidateLicenceResponse> {
  @override
  ValidateLicenceResponse from(Map<String, dynamic> from) =>
      ValidateLicenceResponse(
          stake: JsonStakeMapper().from(from['stake']),
          authorization: from['authorization']);

  @override
  Map<String, dynamic> to(ValidateLicenceResponse from) {
    final map = <String, dynamic>{};
    map["stake"] = JsonStakeMapper().to(from.stake!);
    map["authorization"] = from.authorization;
    return map;
  }
}
