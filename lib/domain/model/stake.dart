import 'dart:convert';

import 'package:stake_calculator/domain/model/previous_stake.dart';

class Stake {
  Stake({
    PreviousStake? previousStake,
    double? losses,
    double? profit,
    int? cycle,
    int? next,
    double? tolerance,
    double? overflow,
    double? recovery,
    bool? decay,
    int? restrictRounds,
    int? recoveryCycles,
    bool? cycleRecovered,
    bool? authRequired,
    bool? forfeit,
    bool? forfeiture,
    bool? forfeited,
    String? id,
    String? createdAt,
    String? updatedAt,
    double? startingStake,
    int? v,
  }) {
    _previousStake = previousStake;
    _losses = losses;
    _profit = profit;
    _cycle = cycle;
    _next = next;
    _tolerance = tolerance;
    _overflow = overflow;
    _recovery = recovery;
    _recoveryCycles = recoveryCycles;
    _cycleRecovered = cycleRecovered;
    _authRequired = authRequired;
    _forfeit = forfeit;
    _forfeiture = forfeiture;
    _forfeited = forfeited;
    _id = id;
    _decay = decay;
    _restrictRounds = restrictRounds;
    _startingStake = startingStake;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  PreviousStake? _previousStake;
  double? _losses;
  double? _profit;
  int? _cycle;
  int? _next;
  bool? _decay;
  int? _restrictRounds;
  double? _tolerance;
  double? _overflow;
  double? _startingStake;
  double? _recovery;
  int? _recoveryCycles;
  bool? _cycleRecovered;
  bool? _authRequired;
  bool? _forfeit;
  bool? _forfeiture;
  bool? _forfeited;
  String? _id;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  PreviousStake? get previousStake => _previousStake;

  double? get losses => _losses;

  double? get startingStake => _startingStake;

  double? get profit => _profit;

  int? get cycle => _cycle;

  int? get restrictRounds => _restrictRounds;

  bool? get decay => _decay;

  int? get next => _next;

  double? get tolerance => _tolerance;

  double? get overflow => _overflow;

  double? get recovery => _recovery;

  int? get recoveryCycles => _recoveryCycles;

  bool? get cycleRecovered => _cycleRecovered;

  bool? get authRequired => _authRequired;

  bool? get forfeit => _forfeit;

  bool? get forfeiture => _forfeiture;

  bool? get forfeited => _forfeited;

  String? get id => _id;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  int? get v => _v;
}
