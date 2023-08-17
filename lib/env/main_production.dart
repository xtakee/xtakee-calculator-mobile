import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stake_calculator/util/config.dart';
import 'package:stake_calculator/util/constants.dart';

import '../di/injector.dart';
import '../main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Config.create(
      baseUrl: baseProductionUrl,
      flavor: Flavor.production,
      webBaseUrl: baseProductionWebUrl,
      payStackPubKey: payStackProductionKey,
      flwPubKey: flutterWaveProductionKey,
      appName: "Xtakee");

  await configureDependencies();

  HttpOverrides.global = HttpOverride();
  runApp(App());
}
