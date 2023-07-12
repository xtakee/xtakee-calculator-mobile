part of 'pip_bloc.dart';

abstract class PipState extends Equatable {
  const PipState();
}

class PipInitial extends PipState {
  @override
  List<Object> get props => [];
}

class OnDataLoaded extends PipState {
  Stake stake;
  List<Odd> tags;

  OnDataLoaded({required this.stake, required this.tags});

  @override
  List<Object?> get props => [stake, tags];
}
