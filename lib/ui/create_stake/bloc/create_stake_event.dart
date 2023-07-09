part of 'create_stake_bloc.dart';

@immutable
abstract class CreateStakeEvent {}

class ValidateLicence extends CreateStakeEvent {
  final String licence;

  ValidateLicence({required this.licence});
}
