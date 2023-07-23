import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/irepository.dart';
import '../../../../domain/model/bundle.dart';

part 'fund_wallet_event.dart';

part 'fund_wallet_state.dart';

class FundWalletBloc extends Bloc<FundWalletEvent, FundWalletState> {
  final _repository = GetIt.instance<IRepository>();

  void getBundles() => add(GetBundles());

  FundWalletBloc() : super(FundWalletInitial()) {
    on<GetBundles>((event, emit) async {
      emit(OnLoading());
      try {
        final bundles = await _repository.getBundles();
        emit(OnDataLoaded(bundles: bundles));
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });
  }
}
