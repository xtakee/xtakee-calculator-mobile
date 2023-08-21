import 'package:stake_calculator/data/remote/model/transaction_history_response.dart';
import 'package:stake_calculator/domain/model/payment_gateway.dart';

import '../model/mandate.dart';
import '../model/transaction.dart';

abstract class ITransactionService {
  Future<TransactionHistoryResponse> getTransactions(
      {required int page, required int limit});

  Future<Transaction> createTransaction(
      {required String bundle, required String gateway});

  Future<Transaction> completeTransaction({required String reference});

  Future<List<Mandate>> getMandates();

  Future<void> deleteMandate({required String mandate});

  Future<List<PaymentGateway>> getPaymentGateways();

  Future<Transaction> chargeMandate(
      {required String mandate, required String bundle, required String url});
}
