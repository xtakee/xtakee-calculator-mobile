import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/irepository.dart';
import '../../../domain/model/stake.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final _repository = GetIt.instance<IRepository>();

  void getStake() => add(GetStake());

  WalletBloc() : super(WalletInitial()) {
    on<WalletEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetStake>((event, emit) async {
      emit(OnLoading());
      try {
        final stake = await _repository.getStake(cached: true);
        emit(OnDataLoaded(stake: stake));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });
  }
}
