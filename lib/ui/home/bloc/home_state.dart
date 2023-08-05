part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class OnCreateStake extends HomeState {
  @override
  List<Object?> get props => [];
}

class OnShowStreakWarning extends HomeState {
  final List<Odd> odds;
  final int cycle;

  OnShowStreakWarning({required this.cycle, required this.odds});

  @override
  List<Object?> get props => [];
}

class OnShowLimitWarning extends HomeState {
  final List<Odd> odds;
  final int cycle;

  OnShowLimitWarning({required this.cycle, required this.odds});

  @override
  List<Object?> get props => [odds, cycle];
}

class OnError extends HomeState {
  final String message;

  OnError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OnLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class OnDataLoaded extends HomeState {
  Stake stake;
  List<Odd> odds;

  OnDataLoaded({required this.odds, required this.stake});

  @override
  List<Object?> get props => [stake, odds];
}

class OnTagAdded extends HomeState {
  Stake stake;
  List<Odd> odds;

  OnTagAdded({required this.odds, required this.stake});

  @override
  List<Object?> get props => [stake, odds];
}
