import 'package:stake_calculator/domain/model/account.dart';
import 'package:stake_calculator/util/mapper.dart';

import 'json_phone_mapper.dart';

class JsonAccountMapper extends Mapper<Map<String, dynamic>, Account> {
  @override
  Account from(Map<String, dynamic> from) => Account(
      phone:
          from['phone'] != null ? JsonPhoneMapper().from(from['phone']) : null,
      id: from['_id'],
      name: from['name'],
      email: from['email']);

  @override
  Map<String, dynamic> to(Account from) {
    final map = <String, dynamic>{};
    if (from.phone != null) {
      map['phone'] = JsonPhoneMapper().to(from.phone!);
    }
    map['_id'] = from.id;
    map['name'] = from.name;
    map['email'] = from.email;
    return map;
  }
}
