part of 'setting_bloc.dart';

@immutable
abstract class SettingEvent {}

class GetStake extends SettingEvent {}

class UpdateStake extends SettingEvent {
  final double profit;
  final double tolerance;
  final bool decay;
  final bool isMultiple;
  final bool keepTag;
  final bool approxAmount;
  final double startingStake;
  final double targetEarning;
  final bool forfeit;
  final String mode;

  final bool clearLosses;
  final int restrictRounds;

  UpdateStake(
      {required this.profit,
      required this.keepTag,
      required this.mode,
      required this.targetEarning,
      required this.approxAmount,
      required this.isMultiple,
      required this.tolerance,
      required this.clearLosses,
      required this.decay,
      required this.startingStake,
      required this.restrictRounds,
      required this.forfeit});
}
