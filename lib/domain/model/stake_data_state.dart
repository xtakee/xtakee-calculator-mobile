import 'package:stake_calculator/domain/model/stake.dart';

abstract class StakeDataState {}

class Success extends StakeDataState {
  final Stake stake;

  Success({required this.stake});
}

class NotFound extends StakeDataState {}
