import 'package:dio/dio.dart';
import 'package:stake_calculator/data/remote/model/transaction_history_response.dart';
import 'package:stake_calculator/domain/model/mandate.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/domain/remote/itransaction_service.dart';

import '../mapper/json_mandate_mapper.dart';
import '../mapper/json_transaction_history_mapper.dart';
import '../mapper/json_transaction_mapper.dart';
import '../model/api_response_state.dart';

class TransactionService extends ITransactionService {
  Dio client;

  TransactionService({required this.client});

  @override
  Future<Transaction> createTransaction({required String bundle}) async {
    try {
      final data = <String, dynamic>{};
      data['bundle'] = bundle;

      final response = await client.post('/transaction', data: data);
      return JsonTransactionMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<TransactionHistoryResponse> getTransactions(
      {required int page, required int limit}) async {
    try {
      final response = await client.get('/transaction/me?page=$page&limit=$limit');
      return JsonTransactionHistoryResponseMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<Transaction> completeTransaction({required String reference}) async {
    try {
      final response = await client.post('/transaction/$reference/finalize');
      return JsonTransactionMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<List<Mandate>> getMandates() async {
    try {
      final response = await client.get('/transaction/mandate');
      return List<Mandate>.from(
          response.data['data'].map((e) => JsonMandateMapper().from(e)));
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<Transaction> chargeMandate(
      {required String mandate,
      required String bundle,
      required String url}) async {
    try {
      final data = <String, dynamic>{};
      data['bundle'] = bundle;
      data['url'] = url;
      data['mandate'] = mandate;

      final response = await client.post('/transaction/charge-mandate', data: data);
      return JsonTransactionMapper().from(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }

  @override
  Future<void> deleteMandate({required String mandate}) async {
    try {
      await client.delete('/transaction/mandate/$mandate');
    } catch (error) {
      throw ApiErrorHandler.parse(error);
    }
  }
}
