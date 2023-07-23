import 'package:stake_calculator/domain/model/bundle.dart';

import '../../util/mapper.dart';

class JsonBundleMapper extends Mapper<Map<String, dynamic>, Bundle> {
  @override
  Bundle from(Map<String, dynamic> from) => Bundle(
      amount: from['amount'],
      value: from['value'],
      additionalCharge: from['additionalCharge'],
      description:
          from['description'] != null ? from['description'].cast<String>() : [],
      id: from['_id'],
      createdAt: from['createdAt'],
      updatedAt: from['updatedAt']);

  @override
  Map<String, dynamic> to(Bundle from) {
    final map = <String, dynamic>{};
    map['amount'] = from.amount;
    map['value'] = from.value;
    map['additionalCharge'] = from.additionalCharge;
    map['description'] = from.description;
    map['_id'] = from.id;
    map['createdAt'] = from.createdAt;
    map['updatedAt'] = from.updatedAt;
    return map;
  }
}
