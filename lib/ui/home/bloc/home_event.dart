part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetStake extends HomeEvent {
  final bool cache;

  GetStake({required this.cache});
}

class CreateStake extends HomeEvent {
  final List<Odd> odds;
  final int cycle;

  CreateStake({required this.odds, required this.cycle});
}

class SetClearLoss extends HomeEvent {
  final bool status;

  SetClearLoss({required this.status});
}

class ResetStake extends HomeEvent {
  final bool won;
  ResetStake({required this.won});
}

class SaveTag extends HomeEvent {
  final Odd odd;

  SaveTag({required this.odd});
}

class DeleteTag extends HomeEvent {
  final int position;
  final bool won;

  DeleteTag({required this.position, required this.won});
}

class SetGameType extends HomeEvent {
  final GameType type;

  SetGameType({required this.type});
}

class UpdateTag extends HomeEvent {
  final Odd odd;
  final int position;

  UpdateTag({required this.odd, required this.position});
}
