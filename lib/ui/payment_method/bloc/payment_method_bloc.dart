import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/itransaction_repository.dart';

part 'payment_method_event.dart';

part 'payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final _repository = GetIt.instance<ITransactionRepository>();

  void deleteMandate({required String mandate}) =>
      add(DeleteMandate(mandate: mandate));

  PaymentMethodBloc() : super(PaymentMethodInitial()) {
    on<DeleteMandate>((event, emit) async {
      emit(OnLoading());

      try {
        await _repository.deleteMandate(mandate: event.mandate);
        emit(OnDeleted(mandate: event.mandate));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });
  }
}
