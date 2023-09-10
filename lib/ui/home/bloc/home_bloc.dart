import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/data/mapper/odds_json_mapper.dart';
import 'package:stake_calculator/data/model/api_response_state.dart';
import 'package:stake_calculator/domain/inotification_repository.dart';
import 'package:stake_calculator/domain/istake_repository.dart';
import 'package:stake_calculator/domain/model/stake.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/game_type.dart';
import 'package:stake_calculator/util/log.dart';
import '../../../domain/model/odd.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _repository = GetIt.instance<IStakeRepository>();
  final _notificationRepository = GetIt.instance<INotificationRepository>();

  void getStake({bool cache = false}) => add(GetStake(cache: cache));

  int getUnReadNotificationsCount() =>
      _notificationRepository.getUnread().length;

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

  HomeBloc() : super(HomeState()) {
    on<SaveTag>((event, emit) async {
      try {
        final odds = await _repository.saveTag(odd: event.odd);
        final stake = await _repository.getStake(cached: true);

        emit(state.copy(
            tags: odds,
            stake: _getStake(stake: stake, tags: odds),
            tagAdded: true));
      } catch (error) {
        emit(state.copy(error: "Error adding tag. Try again"));
      }
    });

    on<SetGameType>((event, emit) async {
      final tags = await _repository.getTags();

      final Odd error = tags.error;
      if (error.odd! > -1) {
        emit(state.copy(error: "Odd must be at least 1.01 for ${error.name}"));
        return;
      }
      try {
        await _repository.saveGameType(type: event.type.index);
        final stake = await _repository.getStake(cached: true);
        final odds = await _repository.getTags();
        emit(state.copy(stake: _getStake(stake: stake, tags: odds)));
      } catch (error) {
        emit(state.copy(error: "Error computing stake. Try again"));
      }
    });

    on<DeleteTag>((event, emit) async {
      emit(state.copy(loading: true));
      try {
        final stake = await _repository.deleteTag(
            position: event.position, won: event.won);

        final odds = await _repository.getTags();
        emit(
            state.copy(tags: odds, stake: _getStake(stake: stake, tags: odds)));
      } catch (error) {
        emit(state.copy(error: "Error deleting tag. Try again"));
      }
    });

    on<UpdateTag>((event, emit) async {
      try {
        final odds = await _repository.updateTag(
            odd: event.odd, position: event.position);

        String? error;
        if (!odds.isValidPairs()) error = "Select a matching pair of tag";

        emit(state.copy(
            tags: odds,
            stake: _getStake(stake: state.stake!, tags: odds),
            error: error));
      } catch (error) {
        emit(state.copy(error: "Error updating tag. Try again"));
      }
    });

    on<GetStake>((event, emit) async {
      if (!event.cache) {
        emit(state.copy(loading: true));
      }
      try {
        final stake =
            await _repository.getStake(cached: event.cache, tags: true);
        final odds = await _repository.getTags();

        emit(
            state.copy(tags: odds, stake: _getStake(stake: stake, tags: odds)));
      } on ApiException catch (error) {
        if (error is! NotFound && error is! BadRequest) {
          emit(state.copy(error: error.toString()));
        } else {
          emit(state.copy(login: true));
        }
      } catch (error) {
        emit(state.copy(error: error.toString()));
      }
    });

    on<ResetStake>((event, emit) async {
      try {
        emit(state.copy(loading: true));
        final stake = await _repository.resetStake(won: event.won);
        final odds = await _repository.getTags();

        emit(
            state.copy(tags: odds, stake: _getStake(stake: stake, tags: odds)));
      } on ApiException catch (error) {
        if (error is NotFound) {
          emit(state.copy(login: true));
        } else {
          emit(state.copy(error: error.toString()));
        }
      }
    });

    on<CreateStake>((event, emit) async {
      try {
        final Odd error = event.odds.error;

        if (error.odd! > -1) {
          emit(
              state.copy(error: "Odd must be at least 1.01 for ${error.name}"));
          return;
        }

        if (!event.odds.isValidPairs()) {
          emit(state.copy(
              error:
                  "Missing pair of tags. Kindly select matching pairs of tags"));
          return;
        }

        if (!event.force) {
          final losses = _getApproximateLosses(stake: state.stake!);

          if (losses >= state.stake!.tolerance!) {
            emit(state.copy(limitWarning: true));
            return;
          } else if (state.stake!.restrictRounds! > 0 &&
              (state.stake!.cycle! >= state.stake!.restrictRounds!)) {
            emit(state.copy(streakWarning: true));
            return;
          }
        }

        emit(state.copy(loading: true));
        final stake = await _repository.computeStake(
            odds: event.odds, cycle: event.cycle);
        final tags = await _repository.getTags();

        emit(state.copy(
            stake: _getStake(stake: stake, tags: tags),
            tags: tags,
            reset: true));
      } on ApiException catch (error) {
        if (error is NotFound) {
          emit(state.copy(login: true));
          return;
        }

        emit(state.copy(error: error.message));
      } catch (error) {
        emit(state.copy(error: "Error computing stake amount. Try again"));
      }
    });
  }
}
