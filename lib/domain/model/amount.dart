
/// cycle : 1
/// next : 2
/// stake : 127
/// expectedWin : 196
class Amount {
  Amount(
      {int? cycle,
      int? next,
      num? odd,
      num? stake,
      num? totalStake,
      int? lot,
      num? expectedWin}) {
    _cycle = cycle;
    _next = next;
    _odd = odd;
    _stake = stake;
    _lot = lot;
    _expectedWin = expectedWin;
    _totalStake = totalStake;
  }

  int? _cycle;
  int? _next;
  num? _odd;
  num? _stake;
  int? _lot;
  num? _expectedWin;
  num? _totalStake;

  int? get cycle => _cycle;

  int? get next => _next;

  num? get odd => _odd;

  num? get stake => _stake;

  num? get expectedWin => _expectedWin;

  num? get totalStake => _totalStake;

  int? get lot => _lot;
}
