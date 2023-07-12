import 'dart:convert';

/// odd : 0
/// value : 0
/// losses : 0
/// overflow : 0
/// recovery : 0
/// recoveryCycles : 0
/// cycleRecovered : true
/// _id : "64a4b6367ea02b92edf89f87"
/// tag : "CRY"

class PreviousStake {
  PreviousStake({num? odd, num? value, String? id, num? lot}) {
    _odd = odd;
    _value = value;
    _id = id;
    _lot = lot;
  }

  num? _odd;
  num? _lot;
  num? _value;
  String? _id;

  num? get odd => _odd;

  num? get value => _value;

  num? get lot => _lot;

  String? get id => _id;
}
