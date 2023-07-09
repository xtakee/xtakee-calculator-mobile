import 'package:stake_calculator/domain/model/phone.dart';
import 'package:stake_calculator/util/mapper.dart';

class JsonPhoneMapper extends Mapper<Map<String, dynamic>, Phone> {
  @override
  Phone from(Map<String, dynamic> from) =>
      Phone(number: from['number'], value: from['value'], code: from['code']);

  @override
  Map<String, dynamic> to(Phone from) {
    final map = <String, dynamic>{};
    map['number'] = from.number;
    map['code'] = from.code;
    map['value'] = from.value;
    return map;
  }
}
