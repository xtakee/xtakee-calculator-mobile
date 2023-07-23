enum MODE { DEBUG, RELEASE }

class Config {
  static MODE buildMode = MODE.RELEASE;
  static const String _payLiveKey =
      "pk_live_9833f8c67365af28857226560114ba0dfd2840b3";
  static const String _payDebugKey =
      "pk_test_d01119fbf70385fea4fd1347fbcb61520a137534";

  static const String _baseUrlDebug = "https://api.staging.xtakee.com/v1";
  //static const String _baseUrlDebug = "http://192.168.1.23:2021/v1";
  static const String _baseUrlLive = "https://api.xtakee.com/v1";

  static String get payStackKey =>
      buildMode == MODE.DEBUG ? _payDebugKey : _payLiveKey;

  static String get baseUrl => buildMode == MODE.DEBUG ? _baseUrlDebug : _baseUrlLive;

  static bool _setDebugMode() {
    buildMode = MODE.DEBUG;
    return true;
  }

  static init() {
    assert(_setDebugMode());
  }
}
