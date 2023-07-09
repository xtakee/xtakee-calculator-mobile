import 'package:flutter/cupertino.dart';
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/domain/model/previous_stake.dart';

import 'dimen.dart';

extension ExtDouble on double {
  double get w => getWidth(this);

  double get h => getHeight(this);
}

extension ExtInt on int {
  double get w => getWidth(this * 1.0);

  double get h => getHeight(this * 1.0);
}

extension ExtPreviosStake on PreviousStake {
  num? get expectedWin => value! * odd!;
}

extension ExtTags on List<Odd> {
  delete(int position) => removeAt(position);

  Odd get(int position) => this[position];

  save(Odd odd) => add(odd);

  update(Odd odd, int position) {
    odd.tag = this[position].tag;
    this[position] = odd;
  }
}

extension ExtOds on List<Odd> {
  Odd get error {
    return firstWhere((e) => e.odd! == 0.00, orElse: () => Odd(odd: -1));
  }
}
