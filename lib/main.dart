import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/home/home.dart';
import 'package:stake_calculator/util/dimen.dart';

import 'di/injector.dart';

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
  await configureDependencies();

  HttpOverrides.global = _HttpOverrides();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setScale(MediaQuery.of(context).size);
    return MaterialApp(
      title: 'Stake Calculator',
      navigatorKey: navigator,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
        fontFamily: 'Poppins'
      ),
      home: const Home(),
    );
  }
}
