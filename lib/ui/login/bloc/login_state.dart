part of 'login_bloc.dart';

@immutable
class LoginState {
  String? emailError;
  String? passwordError;
  String? error;
  bool loading = false;
  bool success = false;

  LoginState(
      {this.success = false,
      this.passwordError,
      this.error,
      this.emailError,
      this.loading = false});

  LoginState copy(
          {String? emailError,
          String? passwordError,
          bool? loading,
          String? error,
          bool? success = false}) =>
      LoginState(
          emailError: emailError ?? this.emailError,
          passwordError: passwordError ?? this.passwordError,
          loading: loading ?? false,
          error: error,
          success: success ?? false);

  @override
  List<Object?> get props =>
      [emailError, passwordError, success, error, loading];
}
