class PaymentGateway {
  String? _name;
  String? _url;
  bool? _active;

  PaymentGateway({String? name, String? url, bool? active}) {
    _name = name;
    _url = url;
    _active = active;
  }

  String get name => _name ?? "";

  String get url => _url ?? "";

  bool get active => _active ?? false;
}
