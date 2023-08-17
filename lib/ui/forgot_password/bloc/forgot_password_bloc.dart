import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final _repository = GetIt.instance<IAccountRepository>();

  void requestOtp({required String email}) => add(RequestOtp(email: email));

  ForgotPasswordBloc() : super(ForgotPasswordState()) {
    on<RequestOtp>((event, emit) async {
      if (event.email.isEmpty) {
        emit(state.copy(emailError: "Email address is required"));
        return;
      }

      emit(state.copy(loading: true));

      try {
        await _repository.sendOtp(email: event.email);
        emit(state.copy(success: true));
      } catch (error) {
        emit(state.copy(error: error.toString()));
      }
    });
  }
}
