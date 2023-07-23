import 'package:stake_calculator/data/mapper/odd_json_mapper.dart';

import 'odd.dart';

class History {
  History({
    num? won,
    num? amount,
    num? round,
    String? id,
    String? stake,
    List<Odd>? odds,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _won = won;
    _round = round;
    _amount = amount;
    _id = id;
    _stake = stake;
    _odds = odds;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  num? _won;
  num? _amount;
  num? _round;
  String? _id;
  String? _stake;
  List<Odd>? _odds;
  String? _createdAt;
  String? _updatedAt;
  num? _v;

  num? get won => _won;

  num? get amount => _amount;

  num? get round => _round;

  String? get id => _id;

  String? get stake => _stake;

  List<Odd>? get odds => _odds;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  num? get v => _v;
}
