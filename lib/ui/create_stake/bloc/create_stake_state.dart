part of 'create_stake_bloc.dart';

@immutable
abstract class CreateStakeState extends Equatable {}

class CreateStakeInitial extends CreateStakeState {
  @override
  List<Object?> get props => [];
}

class OnSuccess extends CreateStakeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnLoading extends CreateStakeState {
  @override
  List<Object?> get props => [];
}

class OnError extends CreateStakeState {
  final String message;
  OnError({required this.message});

  @override
  List<Object?> get props => [];
}
