import 'package:stake_calculator/data/mapper/json_account_mapper.dart';
import 'package:stake_calculator/domain/model/mandate.dart';
import 'package:stake_calculator/util/mapper.dart';

class JsonMandateMapper extends Mapper<Map<String, dynamic>, Mandate> {
  @override
  Mandate from(Map<String, dynamic> from) => Mandate(
      merchant: from['merchant'],
      id: from['_id'],
      account: from['account'] != null
          ? JsonAccountMapper().from(from['account'])
          : null,
      expiryMonth: from['expiryMonth'],
      expiryYear: from['expiryYear'],
      cardType: from['cardType'],
      reusable: from['reusable'],
      channel: from['channel'],
      brand: from['brand'],
      bank: from['bank'],
      bin: from['bin'],
      last4: from['last4']);

  @override
  Map<String, dynamic> to(Mandate from) {
    final map = <String, dynamic>{};
    map['merchant'] = from.merchant;
    map['_id'] = from.id;
    if (from.account != null) {
      map['account'] = JsonAccountMapper().to(from.account!);
    }
    map['expiryMonth'] = from.expiryMonth;
    map['expiryYear'] = from.expiryYear;
    map['cardType'] = from.cardType;
    map['reusable'] = from.reusable;
    map['channel'] = from.channel;
    map['brand'] = from.brand;
    map['bank'] = from.bank;
    map['bin'] = from.bin;
    map['last4'] = from.last4;
    return map;
  }
}
