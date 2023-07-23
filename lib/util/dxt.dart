import 'package:intl/intl.dart'; // for date format
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/domain/model/previous_stake.dart';

import 'dimen.dart';

extension ExtDouble on double {
  double get w => getWidth(this);

  double get h => getHeight(this);

  double get sp => getWidth(this * 1.0);
}

extension ExtInt on int {
  double get w => getWidth(this * 1.0);

  double get h => getHeight(this * 1.0);

  double get sp => getWidth(this * 1.0);
}

extension ExtPreviosStake on PreviousStake {
  num? get expectedWin => value! * odd! * lot!;
}

extension ExtTags on List<Odd> {
  delete(int position) => removeAt(position);

  Odd get(int position) => this[position];

  Odd findByTag(String tag) => firstWhere((element) => element.tag == tag,
      orElse: () => Odd(name: "Default"));

  save(Odd odd) => add(odd);

  update(Odd odd, int position) {
    odd.tag = this[position].tag;
    this[position] = odd;
  }

  int wins() {
    int count = 0;
    forEach((odd) {
      if ((odd.won ?? 0) > 0) count += 1;
    });

    return count;
  }

  String string() => map((e) => e.name).join(", ");
}

extension ExtOds on List<Odd> {
  Odd get error {
    return firstWhere((e) => e.odd! == 0.00, orElse: () => Odd(odd: -1));
  }
}

extension ExtString on String {
  String toDate() => DateFormat.yMMMMd().format(DateTime.parse(this));
  String orEmpty() => this ?? "";
}

extension ExtNullString on String? {
  String orEmpty() => this ?? "";
}
