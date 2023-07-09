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
  PreviousStake({num? odd, num? value, String? id}) {
    _odd = odd;
    _value = value;
    _id = id;
  }

  num? _odd;
  num? _value;
  String? _id;

  num? get odd => _odd;

  num? get value => _value;

  String? get id => _id;
}
