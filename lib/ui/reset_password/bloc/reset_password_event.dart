part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
}

class ResetPassword extends ResetPasswordEvent {
  final String otp;
  final String password;
  final String confirmPassword;

  const ResetPassword({required this.otp, required this.password, required this.confirmPassword});

  @override
  List<Object?> get props => [otp, password, confirmPassword];
}
