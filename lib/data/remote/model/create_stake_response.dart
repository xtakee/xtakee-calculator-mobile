class CreateStakeResponse {
  CreateStakeResponse({
    this.session,
    this.next,
  });

  CreateStakeResponse.fromJson(dynamic json) {
    session = json['session'];
    next = json['next'];
  }

  String? session;
  int? next;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['session'] = session;
    map['next'] = next;
    return map;
  }
}
