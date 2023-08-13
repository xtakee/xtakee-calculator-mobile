part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class Register extends RegisterEvent {
  final String email;
  final String password;
  final String name;
  final Phone phone;

  const Register(
      {required this.phone,
      required this.name,
      required this.password,
      required this.email});

  @override
  List<Object?> get props => [email, password, phone, name];
}
