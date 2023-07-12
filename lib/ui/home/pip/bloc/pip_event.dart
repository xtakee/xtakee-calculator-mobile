part of 'pip_bloc.dart';

abstract class PipEvent extends Equatable {
  const PipEvent();
}

class GetStake extends PipEvent {
  @override
  List<Object?> get props => [];
}

class GetTags extends PipEvent {
  @override
  List<Object?> get props => [];
}

