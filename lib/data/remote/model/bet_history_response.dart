
import '../../../domain/model/history.dart';

class BetHistoryResponse {
  BetHistoryResponse(
      {List<History>? docs,
      num? totalDocs,
      num? count,
      num? page,
      num? limit}) {
    _docs = docs;
    _totalDocs = totalDocs;
    _count = count;
    _page = page;
    _limit = limit;
  }

  List<History>? _docs;
  num? _totalDocs;
  num? _count;
  num? _page;
  num? _limit;

  List<History>? get docs => _docs;

  num? get totalDocs => _totalDocs;

  num? get count => _count;

  num? get page => _page;

  num? get limit => _limit;
}
