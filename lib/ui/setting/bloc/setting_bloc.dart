import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:stake_calculator/domain/irepository.dart';

import '../../../domain/model/stake.dart';

part 'setting_event.dart';

part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final _repository = GetIt.instance<IRepository>();

  void getStake() => add(GetStake());

  void updateStake(
          {required double profit,
          required double tolerance,
          required bool decay,
          required bool clearLosses,
          required bool isMultiple,
          required double statingStake,
          required int restrictRounds,
          required bool forfeit}) =>
      add(UpdateStake(
          profit: profit,
          tolerance: tolerance,
          clearLosses: clearLosses,
          isMultiple: isMultiple,
          staringStake: statingStake,
          decay: decay,
          forfeit: forfeit,
          restrictRounds: restrictRounds));

  SettingBloc() : super(SettingInitial()) {
    on<GetStake>((event, emit) async {
      final stake = await _repository.getStake(cached: true);
      final bool clearLosses = await _repository.getClearLoss();
      emit(OnDataLoaded(stake: stake, clearLosses: clearLosses));
    });

    on<UpdateStake>((event, emit) async {
      if (event.profit < 0.01) {
        emit(OnError(message: "Invalid profit provided"));
        return;
      } else if (event.tolerance < 1) {
        emit(OnError(message: "Invalid tolerance provided"));
        return;
      } else if (event.restrictRounds < 0) {
        emit(OnError(message: "Invalid rounds provided"));
        return;
      } else if (event.staringStake < 0) {
        emit(OnError(message: "Invalid starting stake provided"));
        return;
      }

      emit(OnLoading());
      try {
        await _repository.updateState(
            decay: event.decay,
            isMultiple: event.isMultiple,
            tolerance: event.tolerance,
            profit: event.profit,
            startingStake: event.staringStake,
            forfeit: event.forfeit,
            restrictRounds: event.restrictRounds,
            clearLosses: event.clearLosses);

        emit(OnSuccess());
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });
  }
}
