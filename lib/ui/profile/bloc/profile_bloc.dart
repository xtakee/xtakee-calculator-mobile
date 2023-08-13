import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';
import 'package:stake_calculator/domain/irepository.dart';
import 'package:stake_calculator/domain/model/account.dart';
import 'package:stake_calculator/domain/model/stake.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _repository = GetIt.instance<IRepository>();
  final _accountRepository = GetIt.instance<IAccountRepository>();

  ProfileState _state = ProfileState();

  void getSummary() => add(GetSummary());

  void changePassword(
          {required String newPassword, required String oldPassword}) =>
      add(ChangePassword(newPassword: newPassword, oldPassword: oldPassword));

  ProfileBloc() : super(ProfileState()) {
    on<GetSummary>((event, emit) async {
      emit(_state.copy(accountLoading: true, stakeLoading: true));
      try {
        final account = await _accountRepository.getAccount();
        _state = _state.copy(account: account);
        emit(_state);
      } catch (error) {
        _state = _state.copy(accountError: error.toString());
        emit(_state);
      }

      try {
        final stake = await _repository.getStake(cached: true);
        _state = _state.copy(stake: stake);
        emit(_state);
      } catch (error) {
        _state = _state.copy(stakeError: error.toString());
        emit(_state);
      }
    });

    on<ChangePassword>((event, emit) async {
      if (event.newPassword.isEmpty || event.oldPassword.isEmpty) {
        _state = _state.copy(
            newPassError:
                event.newPassword.isEmpty ? "New Password is required" : null,
            oldPassError: event.oldPassword.isEmpty
                ? "Current Password is required"
                : null);

        emit(_state);
        return;
      }

      emit(_state.copy(loading: true));

      try {
        await _accountRepository.changePassword(
            password: event.oldPassword, newPassword: event.newPassword);

        emit(
            _state.copy(success: true, newPassError: null, oldPassError: null));
      } catch (error) {
        emit(_state.copy(error: error.toString()));
      }
    });
  }
}
