import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/domain/itransaction_repository.dart';
import 'package:stake_calculator/domain/model/transaction.dart';

part 'checkout_event.dart';

part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final _repository = GetIt.instance<ITransactionRepository>();

  void createTransaction({required String bundle}) =>
      add(CreateTransaction(bundle: bundle));

  void completeTransaction({required String reference}) =>
      add(CompleteTransaction(reference: reference));

  CheckoutBloc() : super(CheckoutInitial()) {
    on<CreateTransaction>((event, emit) async {
      emit(OnLoading());
      try {
        final transaction =
            await _repository.createTransaction(bundle: event.bundle);
        emit(OnSuccess(transaction: transaction));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });

    on<CompleteTransaction>((event, emit) async {
      emit(OnLoading());
      try {
        final transaction =
            await _repository.completeTransaction(reference: event.reference);
        emit(OnComplete(transaction: transaction));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });
  }
}
