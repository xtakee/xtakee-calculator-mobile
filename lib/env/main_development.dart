import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stake_calculator/util/config.dart';
import 'package:stake_calculator/util/constants.dart';

import '../di/injector.dart';
import '../main.dart';

final navigator = GlobalKey<NavigatorState>(); //Create a key for navigator

class _HttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Config.create(
      baseUrl: baseDevelopmentUrl,
      payStackPubKey: payStackDevelopmentKey,
      appName: "Xtakee");

  await configureDependencies();

  HttpOverrides.global = _HttpOverrides();
  runApp(const App());
}

