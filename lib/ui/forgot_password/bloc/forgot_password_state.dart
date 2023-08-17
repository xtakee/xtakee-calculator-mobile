part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  String? error;
  String? emailError;
  bool loading;
  bool success;

  ForgotPasswordState(
      {this.error,
      this.success = false,
      this.loading = false,
      this.emailError});

  ForgotPasswordState copy(
          {String? error,
          String? emailError,
          bool success = false,
          bool loading = false}) =>
      ForgotPasswordState(
          error: error,
          emailError: emailError ?? this.emailError,
          success: success,
          loading: loading);

  @override
  List<Object?> get props => [error, emailError, success, loading];
}
