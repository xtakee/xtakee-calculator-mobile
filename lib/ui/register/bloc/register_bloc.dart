
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/domain/model/phone.dart';

import '../../../domain/iaccount_repository.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _accountRepository = GetIt.instance<IAccountRepository>();

  final RegisterState _state = RegisterState();

  void register(
          {required String name,
          required String password,
          required String email,
          required Phone phone}) =>
      add(Register(phone: phone, name: name, password: password, email: email));

  RegisterBloc() : super(RegisterState()) {
    on<Register>((event, emit) async {
      if (event.email.isEmpty ||
          event.password.isEmpty ||
          event.phone.number!.isEmpty ||
          event.name.isEmpty) {
        emit(_state.copy(
            emailError:
                event.email.isEmpty ? "Email address is required" : null,
            passwordError:
                event.password.isEmpty ? "Password is required" : null,
            nameError: event.name.isEmpty ? "Your full name is required" : null,
            phoneError: event.phone.number!.isEmpty
                ? "Phone number is required"
                : null));
        return;
      }

      emit(_state.copy(loading: true));

      try {
        await _accountRepository.register(
            email: event.email.trim(),
            password: event.password,
            name: event.name.trim(),
            phone: event.phone);

        emit(_state.copy(success: true));
      } catch (error) {
        emit(_state.copy(
            error: error.toString(),
            emailError: "",
            passwordError: "",
            phoneError: "",
            nameError: ""));
      }
    });
  }
}
