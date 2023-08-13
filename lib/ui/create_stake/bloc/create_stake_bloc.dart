
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
        emit(OnSuccess());
      } catch (error) {
        emit(OnError(message: "There was an error validating your licence. Try again"));
      }
    });
  }
}
