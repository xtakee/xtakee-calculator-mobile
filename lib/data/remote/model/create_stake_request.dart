class CreateStakeRequest {
  CreateStakeRequest({
      this.profit = 0,
      this.tolerance = 0});

  CreateStakeRequest.fromJson(dynamic json) {
    profit = json['profit'] ?? 0;
    tolerance = json['tolerance'] ?? 0;
  }

  double? profit;
  double? tolerance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profit'] = profit;
    map['tolerance'] = tolerance;
    return map;
  }
}