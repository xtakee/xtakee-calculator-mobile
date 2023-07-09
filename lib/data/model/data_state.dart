import 'package:stake_calculator/domain/model/stake.dart';

abstract class DataState {}

class NotFound extends DataState {}

class Success<T> extends DataState {
  final T data;

  Success({required this.data});
}

class Loading extends DataState {}
class Forbidden extends DataState {}
class BadRequest extends DataState {}
