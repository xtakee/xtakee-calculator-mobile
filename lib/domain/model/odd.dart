
class Odd {
  Odd({
    String? name,
    num? odd,
    String? tag,
  }) {
    _name = name;
    _odd = odd;
    this.tag = tag ?? DateTime.now().microsecondsSinceEpoch.toString();
  }

  String? tag;
  String? _name;
  num? _odd;

  String? get name => _name;
  num? get odd => _odd;
}