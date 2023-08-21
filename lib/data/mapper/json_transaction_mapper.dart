import 'package:stake_calculator/data/mapper/json_account_mapper.dart';
import 'package:stake_calculator/data/mapper/json_bundle_mapper.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/util/mapper.dart';

class JsonTransactionMapper extends Mapper<Map<String, dynamic>, Transaction> {
  @override
  Transaction from(Map<String, dynamic> from) => Transaction(
      channel: from['channel'],
      charge: from['charge'],
      status: from['status'],
      gateway: from['gateway'],
      checkoutUrl: from['checkoutUrl'],
      createdAt: from['createdAt'],
      updatedAt: from['updatedAt'],
      auth: from['auth'],
      id: from['_id'],
      account: from['account'] != null
          ? JsonAccountMapper().from(from['account'])
          : null,
      amount: from['amount'],
      bundle: from['bundle'] != null
          ? JsonBundleMapper().from(from['bundle'])
          : null,
      reference: from['reference'],
      description: from['description'],
      message: from['message'],
      type: from['type']);

  @override
  Map<String, dynamic> to(Transaction from) {
    final map = <String, dynamic>{};
    map['channel'] = from.channel;
    map['charge'] = from.charge;
    map['status'] = from.status;
    map['auth'] = from.auth;
    map['_id'] = from.id;
    if (from.account != null) {
      map['account'] = JsonAccountMapper().to(from.account!);
    }
    map['amount'] = from.amount;
    if (from.bundle != null) {
      map['bundle'] = JsonBundleMapper().to(from.bundle!);
    }
    map['reference'] = from.reference;
    map['checkoutUrl'] = from.checkoutUrl;
    map['createdAt'] = from.createdAt;
    map['updateAt'] = from.updatedAt;
    map['description'] = from.description;
    map['message'] = from.message;
    map['gateway'] = from.gateway;
    map['type'] = from.type;
    return map;
  }
}
