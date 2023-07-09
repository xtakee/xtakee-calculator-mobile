
import '../../../domain/model/odd.dart';

class StakeRequest {
  StakeRequest({
    List<Odd>? odds,
    int? cycle
  }) {
    _odds = odds;
    _cycle = cycle;
  }

  List<Odd>? _odds;
  int? _cycle;

  List<Odd>? get odds => _odds;

  int? get cycle => _cycle;
}
