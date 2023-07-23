import 'package:stake_calculator/domain/model/phone.dart';

class Account {
  Account({
    Phone? phone,
    String? id,
    String? name,
    String? email,}){
    _phone = phone;
    _id = id;
    _name = name;
    _email = email;
  }

  Phone? _phone;
  String? _id;
  String? _name;
  String? _email;

  Phone? get phone => _phone;
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
}
