import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:stake_calculator/domain/model/odd.dart';

import '../../../domain/irepository.dart';

part 'create_stake_event.dart';

part 'create_stake_state.dart';

class CreateStakeBloc extends Bloc<CreateStakeEvent, CreateStakeState> {
  final _repository = GetIt.instance<IRepository>();

  void validateLicence({required String licence}) =>
      add(ValidateLicence(licence: licence));

  CreateStakeBloc() : super(CreateStakeInitial()) {
    on<ValidateLicence>((event, emit) async {
      try {
        emit(OnLoading());
        await _repository.validateLicence(event.licence);
        _repository.saveTag(odd: Odd(name: 'default', odd: 1.10));
        emit(OnSuccess());
      } catch (error) {
        emit(OnError(message: "There was an error validating your licence. Try again"));
      }
    });
  }
}
