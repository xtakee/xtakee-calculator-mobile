import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stake_calculator/util/config.dart';
import 'package:stake_calculator/util/constants.dart';

import '../di/injector.dart';
import '../main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Config.create(
      baseUrl: baseProductionUrl,
      flavor: Flavor.production,
      payStackPubKey: payStackProductionKey,
      flwPubKey: flutterWaveProductionKey,
      appName: "Xtakee");

  await configureDependencies();

  HttpOverrides.global = HttpOverride();
  runApp(const App());
}
