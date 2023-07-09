/// amount : 147.06
/// odd : 1.34
/// tag : "MUN"
/// expectedWin : 197.06
class AmountToStake {
  AmountToStake({
    num? amount,
    num? odd,
    String? tag,
    num? expectedWin,
  }) {
    _amount = amount;
    _odd = odd;
    _tag = tag;
    _expectedWin = expectedWin;
  }

  num? _amount;
  num? _odd;
  String? _tag;
  num? _expectedWin;

  num? get amount => _amount;

  num? get odd => _odd;

  String? get tag => _tag;

  num? get expectedWin => _expectedWin;
}
