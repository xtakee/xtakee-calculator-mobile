import 'package:stake_calculator/domain/model/mandate.dart';

import '../data/remote/model/transaction_history_response.dart';
import 'model/transaction.dart';

abstract class ITransactionRepository {
  Future<TransactionHistoryResponse> getTransactions(
      {required int page, required int limit});

  Future<Transaction> createTransaction(
      {required String bundle, required String gateway});

  Future<Transaction> completeTransaction({required String reference});

  Future<List<Mandate>> getMandates();

  Future<void> deleteMandate({required String mandate});

  Future<Transaction> chargeMandate(
      {required String mandate, required String bundle});
}
