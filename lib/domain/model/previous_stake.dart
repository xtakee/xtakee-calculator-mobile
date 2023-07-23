class PreviousStake {
  PreviousStake(
      {num? odd, this.value, this.totalWin = 0, String? id, num? lot}) {
    _odd = odd;
    _id = id;
    _lot = lot;
  }

  num? _odd;
  num? _lot;
  num? value;
  num totalWin;
  String? _id;

  num? get odd => _odd;

  num? get lot => _lot;

  String? get id => _id;
}
