
import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/home/home.dart';
import 'package:stake_calculator/util/dimen.dart';

final navigator = GlobalKey<NavigatorState>(); //Create a key for navigator

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    setScale(MediaQuery.of(context).size);
    return MaterialApp(
      title: 'Xtakee',
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
