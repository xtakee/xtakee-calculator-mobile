part of 'setting_bloc.dart';

@immutable
abstract class SettingState extends Equatable {}

class SettingInitial extends SettingState {
  @override
  List<Object?> get props => [];
}

class OnLoading extends SettingState {
  @override
  List<Object?> get props => [];
}

class OnError extends SettingState {
  final String message;

  OnError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OnSuccess extends SettingState {
  @override
  List<Object?> get props => [];
}

class OnDataLoaded extends SettingState {
  final Stake stake;
  final bool clearLosses;
  final bool keepTag;

  OnDataLoaded({required this.stake, required this.clearLosses, required this.keepTag});

  @override
  List<Object?> get props => [stake, clearLosses, keepTag];
}
