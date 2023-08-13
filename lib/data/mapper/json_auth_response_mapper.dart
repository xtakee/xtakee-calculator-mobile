import 'package:stake_calculator/data/mapper/json_account_mapper.dart';
import 'package:stake_calculator/data/remote/model/auth_response.dart';
import 'package:stake_calculator/util/mapper.dart';

class JsonAuthResponseMapper
    extends Mapper<Map<String, dynamic>, AuthResponse> {
  @override
  AuthResponse from(Map<String, dynamic> from) => AuthResponse(
      account: JsonAccountMapper().from(from['user']),
      authorization: from['authorization']);

  @override
  Map<String, dynamic> to(AuthResponse from) {
    final map = <String, dynamic>{};
    if (from.account != null) {
      map['account'] = JsonAccountMapper().to(from.account!);
    }
    map['authorization'] = from.authorization;
    return map;
  }
}
