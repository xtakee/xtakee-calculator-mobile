import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:stake_calculator/data/model/api_response_state.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';

import '../../../domain/cache.dart';
import '../../../domain/istake_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _accountRepository = GetIt.instance<IAccountRepository>();

  final _cache = GetIt.instance<Cache>();
  final _repository = GetIt.instance<IStakeRepository>();

  final LoginState _state = LoginState(loading: false);

  void resetCache() => _cache.reset();

  void setOnboarded() => _repository.setOnBoarding(status: true);

  void login({required String password, required String email}) =>
      add(Login(password: password, email: email));

  LoginBloc() : super(LoginState()) {
    on<Login>((event, emit) async {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(_state.copy(
            emailError:
                event.email.isEmpty ? "Email address is required" : null,
            passwordError:
                event.password.isEmpty ? "Password is required" : null,
            error: ""));
        return;
      }

      emit(_state.copy(loading: true, emailError: "", passwordError: ""));

      try {
        await _accountRepository.login(
            email: event.email.trim(), password: event.password);

        emit(_state.copy(success: true));
      } on ApiException catch (error) {
        if (error is BadRequest) {
          emit(_state.copy(
              error: "You have entered an invalid email or password"));
        }else {
          emit(_state.copy(error: error.toString()));
        }
      } catch (error) {
        emit(_state.copy(error: error.toString()));
      }
    });
  }
}
