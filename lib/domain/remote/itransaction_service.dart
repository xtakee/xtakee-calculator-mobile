import '../model/transaction.dart';

abstract class ITransactionService {
  Future<List<Transaction>> getTransactions({required int page, required int limit});

  Future<Transaction> createTransaction({required String bundle});

  Future<Transaction> completeTransaction({required String reference});
}
