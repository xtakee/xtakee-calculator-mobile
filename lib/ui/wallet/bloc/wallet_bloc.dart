import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/domain/itransaction_repository.dart';

import '../../../domain/irepository.dart';
import '../../../domain/model/stake.dart';
import '../../../domain/model/transaction.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final _repository = GetIt.instance<IRepository>();
  final _txRepository = GetIt.instance<ITransactionRepository>();

  List<Transaction> transactions = [];

  void getStake() => add(GetStake());

  void getPayments() => add(const GetPayments(limit: 5, page: 0));

  WalletBloc() : super(WalletInitial()) {
    on<GetPayments>((event, emit) async {
      emit(OnLoading());
      try {
        var tx = await _txRepository.getTransactions(
            page: event.page, limit: event.limit);
        transactions = tx.docs ?? [];
        final stake = await _repository.getStake(cached: true);
        emit(OnPaymentsLoaded(transactions: transactions, stake: stake));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });

    on<GetStake>((event, emit) async {
      try {
        final stake = await _repository.getStake(cached: true);
        emit(OnDataLoaded(stake: stake));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });
  }
}
