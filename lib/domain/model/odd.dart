class Odd {
  Odd(
      {String? name,
      this.isPair,
      num? odd,
      num? won,
      String? id,
      String? tag}) {
    _name = name;
    _odd = odd;
    _won = won;
    _id = id;
    isNew = tag == null;
    this.tag = tag ?? DateTime.now().microsecondsSinceEpoch.toString();
  }

  String? tag;
  String? _name;
  num? _odd;
  num? _won;
  bool? isPair;
  String? _id;
  bool isNew = true;

  String? get name => _name;

  num? get odd => _odd;

  num? get won => _won;

  String? get id => _id;
}
