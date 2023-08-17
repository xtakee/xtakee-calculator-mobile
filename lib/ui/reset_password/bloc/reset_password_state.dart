part of 'reset_password_bloc.dart';

class ResetPasswordState extends Equatable {
  bool loading;
  String? newPasswordError;
  String? confirmPasswordError;
  String? error;
  bool success;

  ResetPasswordState(
      {this.error,
      this.loading = false,
      this.success = false,
      this.confirmPasswordError,
      this.newPasswordError});

  ResetPasswordState copy(
          {bool loading = false,
          String? newPasswordError,
          String? confirmPasswordError,
          String? error,
          bool success = false}) =>
      ResetPasswordState(
          error: error ?? this.error,
          newPasswordError: newPasswordError ?? this.newPasswordError,
          confirmPasswordError:
              confirmPasswordError ?? this.confirmPasswordError,
          loading: loading,
          success: success);

  @override
  List<Object?> get props =>
      [error, newPasswordError, confirmPasswordError, success, loading];
}
