import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../data/remote/model/transaction_history_response.dart';
import '../../../domain/itransaction_repository.dart';

part 'payment_event.dart';

part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final _repository = GetIt.instance<ITransactionRepository>();

  void getTransactions({required int page, required int limit}) =>
      add(GetPayments(limit: limit, page: page));

  PaymentBloc() : super(PaymentInitial()) {
    on<GetPayments>((event, emit) async {
      emit(OnLoading());
      try {
        final response = await _repository.getTransactions(
            page: event.page, limit: event.limit);

        emit(OnDataLoaded(data: response));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });
  }
}
