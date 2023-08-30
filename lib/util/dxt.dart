import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/domain/model/previous_stake.dart';
import 'package:stake_calculator/domain/model/stake.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/ui/commons.dart';

import '../domain/model/history.dart';
import 'dimen.dart';

extension ExtDouble on double {
  double get w => getWidth(this);

  double get h => getHeight(this);

  double get sp => (this * 1.0);
}

extension ExtInt on int {
  double get w => getWidth(this * 1.0);

  double get h => getHeight(this * 1.0);

  double get sp => (this * 1.0);
}

extension ExtStake on Stake {
  int get loosed => (wins - stakes) > 0 ? (wins - stakes) : 0;
}

extension ExtPreviosStake on PreviousStake {
  num? get expectedWin => value! * odd! * odds.length;
}

extension ExtTags on List<Odd> {
  delete(int position) => removeAt(position);

  int pairs() => where((element) => element.isPair == true).toList().length;

  void clearPairs() => forEach((element) {
        element.isPair = false;
      });

  bool isValidPairs() => length == 1 ? true : (pairs() % 2 == 0);

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
  String toDate() => DateFormat.yMMMd().format(DateTime.parse(this));

  String toMonth() => DateFormat.MMMd().format(DateTime.parse(this));

  String toTime() => DateFormat.jm().format(DateTime.parse(this));

  String orEmpty() => this ?? "";

  String toTitleCase() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toCard() {
    switch (toLowerCase()) {
      case "visa":
      case "visacard":
        return Res.visa_card;
      case "verve":
      case "vervecard":
        return Res.verve_card;
      case "master":
      case "mastercard":
        return Res.master_card;
      default:
        return Res.master_card;
    }
  }

  Widget toGateway() {
    switch (this) {
      case "paystack":
        return SvgPicture.asset(
          Res.paystack,
          height: 15.h,
        );
      case "flutterwave":
        return Image.asset(
          Res.flutterwave,
          height: 24.h,
          width: 24.w,
          fit: BoxFit.fill,
        );
      default:
        return Container();
    }
  }

  Color toColor() {
    switch (this) {
      case "success":
        return colorGreen;
      case "attempted":
        return Colors.orange;
      case "failed":
        return Colors.redAccent;
      default:
        return Colors.redAccent;
    }
  }
}

extension ExtNullString on String? {
  String orEmpty() => this ?? "";
}

extension ExtBetHistory on List<History> {
  List<History> wins() => where((e) => e.won! > 0).toList();

  List<History> losses() => where((e) => e.won! == 0).toList();
}
