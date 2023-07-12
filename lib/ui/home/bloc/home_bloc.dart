import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/data/model/api_response_state.dart';
import 'package:stake_calculator/domain/irepository.dart';
import 'package:stake_calculator/domain/model/stake.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/log.dart';

import '../../../domain/model/odd.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _repository = GetIt.instance<IRepository>();

  void getStake({bool cache = false}) => add(GetStake(cache: cache));

  void saveTag(Odd odd) => add(SaveTag(odd: odd));

  void updateTag(Odd odd, int position) =>
      add(UpdateTag(odd: odd, position: position));

  void deleteTag(int position) => add(DeleteTag(position: position));

  void setClearLoss({required bool status}) =>
      add(SetClearLoss(status: status));

  void resetStake() => add(ResetStake());

  void compute({required int cycle, required List<Odd> odds}) =>
      add(CreateStake(odds: odds, cycle: cycle));

  HomeBloc() : super(HomeInitial()) {
    on<SaveTag>((event, emit) async {
      try {
        final odds = await _repository.saveTag(odd: event.odd);
        final stake = await _repository.getStake(cached: true);

        emit(OnTagAdded(odds: odds, stake: stake));
        emit(OnDataLoaded(odds: odds, stake: stake));
      } catch (error) {
        emit(OnError(message: "Error adding tag. Try again"));
      }
    });

    on<DeleteTag>((event, emit) async {
      emit(OnLoading());
      try {
        final stake = await _repository.deleteTag(position: event.position);
        final odds = await _repository.getTags();
        emit(OnDataLoaded(odds: odds, stake: stake));
      } catch (error) {
        Log.e(error);
        emit(OnError(message: "Error deleting tag. Try again"));
      }
    });

    on<UpdateTag>((event, emit) async {
      try {
        final odds = await _repository.updateTag(
            odd: event.odd, position: event.position);
        final stake = await _repository.getStake(cached: true);

        emit(OnDataLoaded(odds: odds, stake: stake));
      } catch (error) {
        Log.d(error);
      }
    });

    on<GetStake>((event, emit) async {
      emit(OnLoading());
      try {
        final stake = await _repository.getStake(cached: event.cache);
        final odds = await _repository.getTags();

        emit(OnDataLoaded(odds: odds, stake: stake));
      } on ApiException catch (error) {
        if (error is NotFound) {
          emit(OnCreateStake());
        }
      } catch (error) {
        Log.e(error);
        emit(OnError(message: error.toString()));
      }
    });

    on<SetClearLoss>((event, emit) {
      _repository.saveClearLoss(status: event.status);
    });

    on<ResetStake>((event, emit) async {
      try {
        emit(OnLoading());
        await _repository.resetStake();
        final stake = await _repository.getStake();
        final odds = await _repository.getTags();

        emit(OnDataLoaded(odds: odds, stake: stake));
      } on ApiException catch (error) {
        if (error is NotFound) {
          emit(OnCreateStake());
        } else {
          emit(OnError(message: error.toString()));
        }
      } catch (error) {
        Log.d(error);
      }
    });

    on<CreateStake>((event, emit) async {
      try {
        final Odd error = event.odds.error;
        if (error.odd! > -1) {
          emit(OnError(message: "Odd must be at least 1.01 for ${error.name}"));
          final temp = await _repository.getStake(cached: true);
          final odds = await _repository.getTags();

          emit(OnDataLoaded(odds: odds, stake: temp));
          return;
        }
        emit(OnLoading());
        await _repository.computeStake(odds: event.odds, cycle: event.cycle);
        final stake = await _repository.getStake();
        final odds = await _repository.getTags();

        emit(OnDataLoaded(odds: odds, stake: stake));
      } on ApiException catch (error) {
        if (error is NotFound) {
          emit(OnCreateStake());
          return;
        }
        emit(OnError(message: "Error computing stake amount. Try again"));
      } catch (error) {
        emit(OnError(message: "Error computing stake amount. Try again"));
      }
    });
  }
}
