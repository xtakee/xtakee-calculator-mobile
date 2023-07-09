import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stake_calculator/di/app_module.dart';

import '../data/local/shared_preference.dart';
import '../domain/cache.dart';

configureDependencies() async {
  final sharedPref = await SharedPreferences.getInstance();
  GetIt.instance.registerSingleton<Cache>(
      SharedPreference(sharedPreferences: sharedPref));

  configureAppModule();
}
