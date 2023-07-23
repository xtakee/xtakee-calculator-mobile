import 'package:stake_calculator/data/mapper/json_history_mapper.dart';
import 'package:stake_calculator/data/remote/model/bet_history_response.dart';
import 'package:stake_calculator/domain/model/history.dart';
import 'package:stake_calculator/util/mapper.dart';

class JsonBetHistoryResponseMapper
    extends Mapper<Map<String, dynamic>, BetHistoryResponse> {
  @override
  from(Map<String, dynamic> from) => BetHistoryResponse(
      docs: from['docs'] != null
          ? List<History>.from(
              from['docs'].map((v) => JsonHistoryMapper().from(v)))
          : [],
      totalDocs: from['totalDocs'],
      count: from['count'],
      page: from['page'],
      limit: from['limit']);

  @override
  Map<String, dynamic> to(from) {
    final map = <String, dynamic>{};
    if (from.docs != null) {
      map['docs'] = from.docs?.map((v) => JsonHistoryMapper().to(v)).toList();
    }
    map['totalDocs'] = from.totalDocs;
    map['count'] = from.count;
    map['page'] = from.page;
    map['limit'] = from.limit;
    return map;
  }
}
