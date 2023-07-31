import 'package:stake_calculator/data/remote/model/transaction_history_response.dart';
import 'package:stake_calculator/domain/model/mandate.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/domain/remote/itransaction_service.dart';

import '../domain/cache.dart';
import '../domain/itransaction_repository.dart';

class TransactionRepository extends ITransactionRepository {
  ITransactionService service;
  Cache cache;
  List<Mandate> _mandates = [];

  TransactionRepository({required this.service, required this.cache});

  @override
  Future<Transaction> createTransaction({required String bundle}) async {
    return await service.createTransaction(bundle: bundle);
  }

  @override
  Future<TransactionHistoryResponse> getTransactions(
      {required int page, required int limit}) async {
    return await service.getTransactions(page: page, limit: limit);
  }

  @override
  Future<Transaction> completeTransaction({required String reference}) async {
    return await service.completeTransaction(reference: reference).then((value) {
      service.getMandates().then((m) {
        _mandates = m;
      });
      return value;
    });
  }

  @override
  Future<List<Mandate>> getMandates() async {
    if (_mandates.isNotEmpty) {
      service.getMandates().then((value) {
        _mandates = value;
      });
      return _mandates;
    } else {
      return await service.getMandates().then((value) {
        _mandates = value;
        return value;
      });
    }
  }

  @override
  Future<Transaction> chargeMandate(
      {required String mandate, required String bundle}) async {
    return await service.chargeMandate(
        mandate: mandate, bundle: bundle, url: "https://staging.xtakee.com");
  }

  @override
  Future<void> deleteMandate({required String mandate}) async {
    return await service.deleteMandate(mandate: mandate).then((value) {
      _mandates.removeWhere((element) => element.id == mandate);
      return;
    });
  }
}
