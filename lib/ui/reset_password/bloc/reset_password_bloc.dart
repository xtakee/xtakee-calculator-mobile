import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final _repository = GetIt.instance<IAccountRepository>();

  void resetPassword(
          {required String otp,
          required String password,
          required String confirmPassword}) =>
      add(ResetPassword(
          otp: otp, password: password, confirmPassword: confirmPassword));

  ResetPasswordBloc() : super(ResetPasswordState()) {
    on<ResetPassword>((event, emit) async {
      if (event.confirmPassword.isEmpty || event.password.isEmpty) {
        emit(state.copy(
            newPasswordError:
                event.password.isEmpty ? "Password is required" : null,
            confirmPasswordError: event.confirmPassword.isEmpty
                ? "Confirm password is required"
                : null));
        return;
      }

      if (event.password != event.confirmPassword) {
        emit(state.copy(
            newPasswordError: null,
            confirmPasswordError: "Passwords do not match"));
        return;
      }

      emit(state.copy(loading: true));

      try {
        await _repository.resetPassword(
            otp: event.otp, password: event.password);
        emit(state.copy(success: true));
      } catch (error) {
        emit(state.copy(error: error.toString()));
      }
    });
  }
}
