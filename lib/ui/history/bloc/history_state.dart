part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  @override
  List<Object> get props => [];
}

class OnLoading extends HistoryState {
  @override
  List<Object?> get props => [];
}

class OnDataLoaded extends HistoryState {
  final BetHistoryResponse data;

  const OnDataLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class OnError extends HistoryState {
  final String message;

  const OnError({required this.message});

  @override
  List<Object?> get props => [];
}
