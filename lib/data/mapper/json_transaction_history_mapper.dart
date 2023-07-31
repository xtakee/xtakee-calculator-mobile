import 'package:stake_calculator/data/mapper/json_history_mapper.dart';
import 'package:stake_calculator/data/mapper/json_transaction_mapper.dart';
import 'package:stake_calculator/data/remote/model/bet_history_response.dart';
import 'package:stake_calculator/data/remote/model/transaction_history_response.dart';
import 'package:stake_calculator/domain/model/history.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/util/mapper.dart';

class JsonTransactionHistoryResponseMapper
    extends Mapper<Map<String, dynamic>, TransactionHistoryResponse> {
  @override
  from(Map<String, dynamic> from) => TransactionHistoryResponse(
      docs: from['docs'] != null
          ? List<Transaction>.from(
              from['docs'].map((v) => JsonTransactionMapper().from(v)))
          : [],
      totalDocs: from['totalDocs'],
      count: from['count'],
      nextPage: from['nextPage'],
      prevPage: from['prevPage'],
      page: from['page'],
      limit: from['limit']);

  @override
  Map<String, dynamic> to(from) {
    final map = <String, dynamic>{};
    if (from.docs != null) {
      map['docs'] =
          from.docs?.map((v) => JsonTransactionMapper().to(v)).toList();
    }
    map['totalDocs'] = from.totalDocs;
    map['count'] = from.count;
    map['page'] = from.page;
    map['prevPage'] = from.prevPage;
    map['nextPage'] = from.nextPage;
    map['limit'] = from.limit;
    return map;
  }
}
