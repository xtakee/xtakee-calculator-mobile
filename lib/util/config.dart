import 'dart:io';

enum Flavor { development, production }

class HttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Config {
  String appName = "";
  String baseUrl = "";
  Flavor flavor = Flavor.development;
  String payStackPubKey = "";

  static Config shared = Config.create();

  factory Config.create(
      {String baseUrl = "",
      String appName = "",
      Flavor flavor = Flavor.development,
      String payStackPubKey = ""}) {
    return shared = Config(
        appName: appName,
        flavor: flavor,
        baseUrl: baseUrl,
        payStackPubKey: payStackPubKey);
  }

  Config(
      {required this.flavor,
      required this.payStackPubKey,
      required this.baseUrl,
      required this.appName});
}
