part of 'register_bloc.dart';

class RegisterState extends Equatable {
  String? nameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  bool success;
  bool loading;
  String? error;

  RegisterState(
      {this.passwordError,
      this.emailError,
      this.nameError,
      this.phoneError,
      this.error,
      this.success = false,
      this.loading = false});

  RegisterState copy(
          {String? passwordError,
          String? emailError,
          String? nameError,
          String? phoneError,
          String? error,
          bool? success,
          bool? loading}) =>
      RegisterState(
          emailError: emailError ?? this.emailError,
          nameError: nameError ?? this.nameError,
          phoneError: phoneError ?? this.phoneError,
          passwordError: passwordError ?? this.passwordError,
          error: error,
          success: success ?? false,
          loading: loading ?? false);

  @override
  List<Object?> get props => [
        nameError,
        passwordError,
        emailError,
        error,
        success,
        loading,
        phoneError
      ];
}
