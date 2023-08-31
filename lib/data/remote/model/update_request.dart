import 'dart:convert';

/// session : "647fc1da744a8daddd2f6538"
/// profit : 50
/// tolerance : 50000
class UpdateRequest {
  UpdateRequest(
      {double? profit,
      double? startingStake,
      double? tolerance,
      bool? decay,
      String? mode,
      bool? approxAmount,
      bool? forfeit,
      int? restrictRounds}) {
    _startingStake = startingStake;
    _profit = profit;
    _approxAmount = approxAmount;
    _tolerance = tolerance;
    _restrictRounds = restrictRounds;
    _decay = decay;
    _mode = mode;
    _forfeit = forfeit;
  }

  double? _profit;
  double? _startingStake;
  double? _tolerance;
  int? _restrictRounds;
  bool? _forfeit;
  String? _mode;
  bool? _approxAmount;
  bool? _decay;

  double? get profit => _profit;

  double? get tolerance => _tolerance;

  double? get startingStake => _startingStake;

  bool? get decay => _decay;

  bool? get approxAmount => _approxAmount;

  String get mode => _mode ?? "";

  bool? get forfeit => _forfeit;

  int? get restrictRounds => _restrictRounds;
}
