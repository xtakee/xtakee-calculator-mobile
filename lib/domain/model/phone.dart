/// number : "07069084607"
/// code : "+234"
/// value : "+2347069084607"
class Phone {
  Phone({
    String? number,
    String? code,
    String? value,}){
    _number = number;
    _code = code;
    _value = value;
  }

  String? _number;
  String? _code;
  String? _value;

  String? get number => _number;
  String? get code => _code;
  String? get value => _value;
}