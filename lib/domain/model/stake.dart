import 'dart:convert';

import 'package:stake_calculator/domain/model/previous_stake.dart';

class Stake {
  Stake({
    PreviousStake? previousStake,
    this.losses,
    this.gameType,
    double? profit,
    bool? isWiningStreak,
    int? cycle,
    int? coins,
    int? stakes,
    int? next,
    int? wins,
    double? tolerance,
    double? overflow,
    double? recovery,
    num? cumLosses,
    bool? decay,
    int? restrictRounds,
    int? recoveryCycles,
    bool? cycleRecovered,
    bool? authRequired,
    bool? forfeit,
    bool? forfeiture,
    bool? rounded,
    bool? forfeited,
    double? targetEarning,
    double? earning,
    String? id,
    String? mode,
    String? createdAt,
    String? updatedAt,
    double? startingStake,
    int? v,
  }) {
    _previousStake = previousStake;
    _profit = profit;
    _cumLosses = cumLosses;
    _cycle = cycle;
    _next = next;
    _wins = wins;
    _mode = mode;
    _isWiningStreak = isWiningStreak;
    _rounded = rounded;
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
    _targetEarning = targetEarning;
    _earning = earning;
    _coins = coins;
    _stakes = stakes;
    _decay = decay;
    _restrictRounds = restrictRounds;
    _startingStake = startingStake;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  PreviousStake? _previousStake;
  double? losses;
  double? _targetEarning;
  double? _earning;
  num? _cumLosses;
  int? gameType;
  double? _profit;
  int? _cycle;
  int? _next;
  int? _wins;
  int? _coins;
  int? _stakes;
  bool? _decay;
  int? _restrictRounds;
  double? _tolerance;
  double? _overflow;
  double? _startingStake;
  double? _recovery;
  int? _recoveryCycles;
  bool? _cycleRecovered;
  bool? _rounded;
  bool? _isWiningStreak;
  bool? _authRequired;
  bool? _forfeit;
  bool? _forfeiture;
  bool? _forfeited;
  String? _id;
  String? _mode;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  PreviousStake? get previousStake => _previousStake;

  double? get startingStake => _startingStake;

  double? get profit => _profit;

  double get earning => _earning ?? 0;

  double get targetEarning => _targetEarning ?? 0;

  num? get cumLosses => _cumLosses;

  bool get rounded => _rounded ?? false;

  bool get isWiningStreak => _isWiningStreak ?? false;

  int? get cycle => _cycle;

  int? get coins => _coins;

  int get balance => (_coins ?? 0) - (_stakes ?? 0);

  int get stakes => _stakes ?? 0;

  int? get restrictRounds => _restrictRounds;

  bool? get decay => _decay;

  int? get next => _next;

  int get wins => _wins ?? 0;

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

  String get mode => _mode ?? "";

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  int? get v => _v;
}
