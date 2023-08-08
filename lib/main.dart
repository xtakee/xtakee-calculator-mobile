import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/home/home.dart';
import 'package:stake_calculator/ui/onboarding/onboarding.dart';
import 'package:stake_calculator/util/dimen.dart';

import 'domain/irepository.dart';

final navigator = GlobalKey<NavigatorState>(); //Create a key for navigator

class App extends StatelessWidget {
  final _repository = GetIt.instance<IRepository>();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    setScale(MediaQuery.of(context).size);
    final onBoarded = _repository.getOnBoarding();

    return MaterialApp(
      title: 'Xtakee',
      navigatorKey: navigator,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
          fontFamily: 'Poppins'),
      home: onBoarded ? const Home() : const OnBoarding(),
    );
  }
}
