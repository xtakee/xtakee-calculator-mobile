class Odd {
  Odd(
      {String? name,
      this.isPair,
      this.odd,
      num? won,
      String? id,
      int? cycle,
      String? tag}) {
    _name = name;
    _won = won;
    _cycle = cycle ?? 0;
    _id = id;
    isNew = tag == null;
    this.tag = tag ?? DateTime.now().microsecondsSinceEpoch.toString();
  }

  String? tag;
  String? _name;
  num? odd;
  num? _won;
  int? _cycle;
  bool? isPair;
  String? _id;
  bool isNew = true;

  String? get name => _name;

  int? get cycle => _cycle ?? 0;

  num? get won => _won;

  String? get id => _id;
}
