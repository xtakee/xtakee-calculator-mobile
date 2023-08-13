import 'odd.dart';

class PreviousStake {
  PreviousStake(
      {num? odd,
      this.value,
      this.totalWin = 0,
      String? id,
      num? lot,
      List<Odd>? odds}) {
    _odd = odd;
    _id = id;
    _lot = lot;
    _odds = odds;
  }

  num? _odd;
  List<Odd>? _odds;
  num? _lot;
  num? value;
  num totalWin;
  String? _id;

  num? get odd => _odd;

  List<Odd> get odds => _odds ?? [];

  num? get lot => _lot;

  String? get id => _id;
}
