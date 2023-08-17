import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';
import 'package:stake_calculator/domain/istake_repository.dart';
import 'package:stake_calculator/domain/model/account.dart';
import 'package:stake_calculator/domain/model/stake.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _repository = GetIt.instance<IStakeRepository>();
  final _accountRepository = GetIt.instance<IAccountRepository>();

  void getSummary() => add(GetSummary());

  void changePassword(
          {required String newPassword, required String oldPassword}) =>
      add(ChangePassword(newPassword: newPassword, oldPassword: oldPassword));

  ProfileBloc() : super(ProfileState()) {
    on<GetSummary>((event, emit) async {
      emit(state.copy(accountLoading: true, stakeLoading: true));
      try {
        final account = await _accountRepository.getAccount();
        emit(state.copy(account: account));
      } catch (error) {
        emit(state.copy(accountError: error.toString()));
      }

      try {
        final stake = await _repository.getStake(cached: true);
        emit(state.copy(stake: stake));
      } catch (error) {
        emit(state.copy(stakeError: error.toString()));
      }
    });

    on<ChangePassword>((event, emit) async {
      if (event.newPassword.isEmpty || event.oldPassword.isEmpty) {

        emit(state.copy(
            newPassError:
            event.newPassword.isEmpty ? "New Password is required" : null,
            oldPassError: event.oldPassword.isEmpty
                ? "Current Password is required"
                : null));
        return;
      }

      emit(state.copy(loading: true, newPassError: "", oldPassError: ""));

      try {
        await _accountRepository.changePassword(
            password: event.oldPassword, newPassword: event.newPassword);

        emit(
            state.copy(success: true, newPassError: null, oldPassError: null));
      } catch (error) {
        emit(state.copy(error: error.toString()));
      }
    });
  }
}
