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
  final double staringStake;
  final bool forfeit;
  final bool clearLosses;
  final int restrictRounds;

  UpdateStake(
      {required this.profit,
      required this.keepTag,
      required this.approxAmount,
      required this.isMultiple,
      required this.tolerance,
      required this.clearLosses,
      required this.decay,
      required this.staringStake,
      required this.restrictRounds,
      required this.forfeit});
}
