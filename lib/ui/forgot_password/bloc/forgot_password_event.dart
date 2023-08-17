part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
}

class RequestOtp extends ForgotPasswordEvent {
  final String email;

  const RequestOtp({required this.email});

  @override
  List<Object?> get props => [email];
}
