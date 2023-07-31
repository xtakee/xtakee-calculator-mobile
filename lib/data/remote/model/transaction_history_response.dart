import 'package:stake_calculator/domain/model/transaction.dart';

class TransactionHistoryResponse {
  TransactionHistoryResponse(
      {List<Transaction>? docs,
      num? totalDocs,
      num? count,
      num? page,
      num? nextPage,
      num? prevPage,
      num? limit}) {
    _docs = docs;
    _totalDocs = totalDocs;
    _count = count;
    _page = page;
    _limit = limit;
    _nextPage = nextPage;
    _prevPage = prevPage;
  }

  List<Transaction>? _docs;
  num? _totalDocs;
  num? _count;
  num? _page;
  num? _limit;
  num? _nextPage;
  num? _prevPage;

  List<Transaction>? get docs => _docs;

  num? get totalDocs => _totalDocs;

  num? get count => _count;

  num? get page => _page;

  num? get prevPage => _prevPage;

  num? get nextPage => _nextPage;

  num? get limit => _limit;
}
