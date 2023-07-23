import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/domain/remote/itransaction_service.dart';

import '../domain/cache.dart';
import '../domain/itransaction_repository.dart';

class TransactionRepository extends ITransactionRepository {
  ITransactionService service;
  Cache cache;

  TransactionRepository({required this.service, required this.cache});

  @override
  Future<Transaction> createTransaction({required String bundle}) async {
    return await service.createTransaction(bundle: bundle);
  }

  @override
  Future<List<Transaction>> getTransactions(
      {required int page, required int limit}) async {
    return await service.getTransactions(page: page, limit: limit);
  }

  @override
  Future<Transaction> completeTransaction({required String reference}) async {
    return await service.completeTransaction(reference: reference);
  }
}
