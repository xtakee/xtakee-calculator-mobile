import 'package:stake_calculator/domain/model/payment_gateway.dart';
import 'package:stake_calculator/util/mapper.dart';

class JsonPaymentGatewayMapper
    extends Mapper<Map<String, dynamic>, PaymentGateway> {
  @override
  PaymentGateway from(Map<String, dynamic> from) => PaymentGateway(
      name: from['name'], url: from['url'], active: from['active']);

  @override
  Map<String, dynamic> to(PaymentGateway from) {
    final map = <String, dynamic>{};
    map['active'] = from.active;
    map['url'] = from.url;
    map['name'] = from.name;
    return map;
  }
}
