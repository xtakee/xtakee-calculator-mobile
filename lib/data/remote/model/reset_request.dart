
class ResetRequest {
  ResetRequest({
      bool? losses, bool? won}){
    _losses = losses;
    _won = won;
}

  ResetRequest.fromJson(dynamic json) {
    _losses = json['losses'];
  }

  bool? _losses;
  bool? _won;

  bool? get losses => _losses;
  bool? get won => _won;
}