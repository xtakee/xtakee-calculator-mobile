import 'dart:convert';
/// session : "647fc1da744a8daddd2f6538"
/// losses : true
ResetRequest resetRequestFromJson(String str) => ResetRequest.fromJson(json.decode(str));
String resetRequestToJson(ResetRequest data) => json.encode(data.toJson());

class ResetRequest {
  ResetRequest({
      bool? losses}){
    _losses = losses;
}

  ResetRequest.fromJson(dynamic json) {
    _losses = json['losses'];
  }

  bool? _losses;

  bool? get losses => _losses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['losses'] = _losses;
    return map;
  }
}