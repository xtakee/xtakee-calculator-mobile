import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/domain/itransaction_repository.dart';
import 'package:stake_calculator/domain/model/mandate.dart';
import 'package:stake_calculator/domain/model/transaction.dart';

import '../../../domain/model/payment_gateway.dart';

part 'checkout_event.dart';

part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final _repository = GetIt.instance<ITransactionRepository>();

  Mandate? selected;
  final List<Transaction> _transactions = [];
  List<Mandate> mandates = [];
  List<PaymentGateway> gateways = [];

  void createTransaction({required String bundle, required String gateway}) =>
      add(CreateTransaction(bundle: bundle, gateway: gateway));

  void chargeMandate({required String bundle}) =>
      add(ChargeMandate(mandate: selected!.id!, bundle: bundle));

  void completeTransaction({required String reference}) =>
      add(CompleteTransaction(reference: reference));

  void getMandates() => add(GetMandates());

  void getGateways() => add(GetGateways());

  CheckoutBloc() : super(CheckoutInitial()) {
    on<CreateTransaction>((event, emit) async {
      emit(OnLoading());
      try {
        Transaction? transaction = _transactions
            .where((tr) => tr.gateway == event.gateway)
            .firstOrNull;

        if (transaction != null) {
          emit(OnSuccess(transaction: transaction));
          return;
        }
        transaction = await _repository.createTransaction(
            bundle: event.bundle, gateway: event.gateway);

        _transactions.add(transaction);

        emit(OnSuccess(transaction: transaction));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });

    on<ChargeMandate>((event, emit) async {
      emit(OnLoading());
      try {
        final transaction = await _repository.chargeMandate(
            mandate: event.mandate, bundle: event.bundle);

        emit(OnComplete(transaction: transaction));
      } catch (error) {
        emit(OnTimeOutError());
      }
    });

    on<GetMandates>((event, emit) async {
      emit(OnLoading());
      try {
        mandates = await _repository.getMandates();
        selected = mandates.firstOrNull;
        emit(OnMandates(mandates: mandates));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });

    on<GetGateways>((event, emit) async {
      emit(OnLoading());
      try {
        gateways = await _repository.getPaymentGateways();
        emit(OnPaymentGateway(gateways: gateways));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });

    on<CompleteTransaction>((event, emit) async {
      emit(OnLoading());
      try {
        final transaction =
            await _repository.completeTransaction(reference: event.reference);
        if (transaction.status != "success") {
          emit(OnTimeOutError());
        } else {
          emit(OnComplete(transaction: transaction));
        }
      } catch (error) {
        emit(OnTimeOutError());
      }
    });
  }
}
