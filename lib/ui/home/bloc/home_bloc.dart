import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/data/model/api_response_state.dart';
import 'package:stake_calculator/domain/irepository.dart';
import 'package:stake_calculator/domain/model/stake.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/game_type.dart';
import '../../../domain/model/odd.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _repository = GetIt.instance<IRepository>();

  void getStake({bool cache = false}) => add(GetStake(cache: cache));

  bool isHomeToured() => _repository.getHomeTour();

  void setHomeToured() => _repository.setHomeTour(status: true);

  void saveTag(Odd odd) => add(SaveTag(odd: odd));

  void setGameType({required GameType type}) => add(SetGameType(type: type));

  void updateTag(Odd odd, int position) =>
      add(UpdateTag(odd: odd, position: position));

  void deleteTag({required int position, bool won = false}) =>
      add(DeleteTag(position: position, won: won));

  void resetStake({bool won = false}) => add(ResetStake(won: won));

  void compute(
          {required int cycle, required List<Odd> odds, bool force = false}) =>
      add(CreateStake(odds: odds, cycle: cycle, force: force));

  Stake _getSinglesAmount(
      {required List<Odd> tags, required Stake stake, bool isSingle = false}) {
    if (!isSingle || tags.length == 1) {
      return stake..previousStake?.totalWin = stake.previousStake!.expectedWin!;
    }

    num product =
        tags.reduce((a, b) => Odd(odd: (a.odd ?? 0) * (b.odd ?? 0))).odd ?? 0;

    num totalWin = product * (stake.previousStake?.value ?? 0);

    return stake
      ..previousStake?.totalWin = totalWin
      ..losses = (stake.previousStake?.value ?? 0) * 1.0;
  }

  Stake _getStake({required Stake stake, required List<Odd> tags}) {
    int gameType = _repository.getGameType();
    if (tags.length == 1) {
      _repository.saveGameType(type: 1);
      gameType = 1;
    }

    return _getSinglesAmount(
        tags: tags, stake: stake, isSingle: gameType == GameType.SINGLE.index)
      ..gameType = gameType;
  }

  double _getApproximateLosses({required Stake stake}) {
    double profit = stake.profit! * stake.next!;
    double amount = (profit + stake.losses!) / (stake.previousStake!.odd! - 1);
    return (amount < stake.startingStake! ? stake.startingStake! : amount) +
        stake.losses!;
  }

  HomeBloc() : super(HomeInitial()) {
    on<SaveTag>((event, emit) async {
      try {
        final odds = await _repository.saveTag(odd: event.odd);
        final stake = await _repository.getStake(cached: true);

        emit(
            OnTagAdded(odds: odds, stake: _getStake(stake: stake, tags: odds)));
        emit(OnDataLoaded(
            odds: odds, stake: _getStake(stake: stake, tags: odds)));
      } catch (error) {
        emit(OnError(message: "Error adding tag. Try again"));
      }
    });

    on<SetGameType>((event, emit) async {
      final tags = await _repository.getTags();
      final stake = await _repository.getStake(cached: true);

      final Odd error = tags.error;
      if (error.odd! > -1) {
        emit(OnError(message: "Odd must be at least 1.01 for ${error.name}"));

        emit(OnDataLoaded(
            odds: tags, stake: _getStake(stake: stake, tags: tags)));
        return;
      }
      try {
        await _repository.saveGameType(type: event.type.index);
        emit(OnDataLoaded(
            odds: tags, stake: _getStake(stake: stake, tags: tags)));
      } catch (error) {
        emit(OnError(message: "Error computing stake. Try again"));
      }
    });

    on<DeleteTag>((event, emit) async {
      emit(OnLoading());
      try {
        final stake = await _repository.deleteTag(
            position: event.position, won: event.won);
        final odds = await _repository.getTags();
        emit(OnDataLoaded(
            odds: odds, stake: _getStake(stake: stake, tags: odds)));
      } catch (error) {
        emit(OnError(message: "Error deleting tag. Try again"));
      }
    });

    on<UpdateTag>((event, emit) async {
      try {
        final odds = await _repository.updateTag(
            odd: event.odd, position: event.position);
        final stake = await _repository.getStake(cached: true);

        emit(OnDataLoaded(
            odds: odds, stake: _getStake(stake: stake, tags: odds)));
      } catch (error) {}
    });

    on<GetStake>((event, emit) async {
      if (!event.cache) {
        emit(OnLoading());
      }
      try {
        final stake = await _repository.getStake(cached: event.cache);
        final odds = await _repository.getTags();

        emit(OnDataLoaded(
            odds: odds, stake: _getStake(stake: stake, tags: odds)));
      } on ApiException catch (error) {
        if (error is NotFound || error is BadRequest) {
          emit(OnCreateStake());
        } else {
          try {
            final stake = await _repository.getStake(cached: true);
            final odds = await _repository.getTags();
            emit(OnError(message: error.toString()));
            emit(OnDataLoaded(
                odds: odds, stake: _getStake(stake: stake, tags: odds)));
          } catch (e) {
            emit(OnCreateStake());
          }
        }
      } catch (error) {
        emit(OnError(message: error.toString()));
      }
    });

    on<ResetStake>((event, emit) async {
      try {
        emit(OnLoading());
        final stake = await _repository.resetStake(won: event.won);
        final odds = await _repository.getTags();

        emit(OnDataLoaded(
            odds: odds, stake: _getStake(stake: stake, tags: odds)));
      } on ApiException catch (error) {
        if (error is NotFound) {
          emit(OnCreateStake());
        } else {
          emit(OnError(message: error.message));
        }
      }
    });

    on<CreateStake>((event, emit) async {
      try {
        final Odd error = event.odds.error;
        final temp = await _repository.getStake(cached: true);

        if (error.odd! > -1) {
          emit(OnError(message: "Odd must be at least 1.01 for ${error.name}"));
          final odds = await _repository.getTags();

          emit(OnDataLoaded(
              odds: odds, stake: _getStake(stake: temp, tags: odds)));
          return;
        }

        if (!event.force) {
          final losses = _getApproximateLosses(stake: temp);

          if (losses >= temp.tolerance!) {
            emit(OnShowLimitWarning(odds: event.odds, cycle: event.cycle));
            return;
          } else if (temp.restrictRounds! > 0 &&
              (temp.cycle! >= temp.restrictRounds!)) {
            emit(OnShowStreakWarning(odds: event.odds, cycle: event.cycle));
            return;
          }
        }

        emit(OnLoading());
        final stake = await _repository.computeStake(
            odds: event.odds, cycle: event.cycle);
        final odds = await _repository.getTags();

        emit(OnDataLoaded(
            odds: odds, stake: _getStake(stake: stake, tags: odds)));
      } on ApiException catch (error) {
        if (error is NotFound) {
          emit(OnCreateStake());
          return;
        }

        final stake = await _repository.getStake(cached: true);
        final odds = await _repository.getTags();

        emit(OnError(message: error.message));
        emit(OnDataLoaded(
            odds: odds, stake: _getStake(stake: stake, tags: odds)));
      } catch (error) {
        emit(OnError(message: "Error computing stake amount. Try again"));
      }
    });
  }
}
