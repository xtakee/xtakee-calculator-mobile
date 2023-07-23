
class Bundle {
  Bundle({
    num? amount,
    int? value,
    num? additionalCharge,
    List<String>? description,
    String? id,
    String? createdAt,
    String? updatedAt,
    num? v,}) {
    _amount = amount;
    _value = value;
    _additionalCharge = additionalCharge;
    _description = description;
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  num? _amount;
  int? _value;
  num? _additionalCharge;
  List<String>? _description;
  String? _id;
  String? _createdAt;
  String? _updatedAt;
  num? _v;

  num? get amount => _amount;

  int? get value => _value;

  num? get additionalCharge => _additionalCharge;

  List<String>? get description => _description;

  String? get id => _id;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  num? get v => _v;
}
