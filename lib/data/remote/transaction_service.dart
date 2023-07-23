import 'package:dio/dio.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/domain/remote/itransaction_service.dart';

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
  Future<List<Transaction>> getTransactions(
      {required int page, required int limit}) async {
    try {
      final response = await client.get('/transaction?page=$page&limit=$limit');
      return List<Transaction>.from(response.data['data']['doc']
          .map((e) => JsonTransactionMapper().from(e)));
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
}
