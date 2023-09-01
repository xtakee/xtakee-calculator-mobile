import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stake_calculator/util/config.dart';
import 'package:stake_calculator/util/constants.dart';

import '../di/injector.dart';
import '../main.dart';

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
  await Firebase.initializeApp();

  Config.create(
      baseUrl: baseDevelopmentUrl,
      webBaseUrl: baseDevelopmentWebUrl,
      payStackPubKey: payStackDevelopmentKey,
      flwPubKey: flutterWaveDevelopmentKey,
      appName: "Xtakee-Debug");

  await configureDependencies();

  HttpOverrides.global = _HttpOverrides();
  runApp(App());
}
