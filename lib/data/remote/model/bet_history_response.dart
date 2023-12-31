import '../../../domain/model/history.dart';

class BetHistoryResponse {
  BetHistoryResponse(
      {List<History>? docs,
      num? totalDocs,
      num? count,
      num? nextPage,
      num? prevPage,
      num? page,
      num? limit}) {
    _docs = docs;
    _totalDocs = totalDocs;
    _count = count;
    _page = page;
    _limit = limit;
    _nextPage = nextPage;
    _prevPage = prevPage;
  }

  List<History>? _docs;
  num? _totalDocs;
  num? _count;
  num? _page;
  num? _nextPage;
  num? _prevPage;
  num? _limit;

  List<History>? get docs => _docs;

  num? get totalDocs => _totalDocs;

  num? get count => _count;

  num? get page => _page;

  num? get prevPage => _prevPage;

  num? get nextPage => _nextPage;

  num? get limit => _limit;
}
