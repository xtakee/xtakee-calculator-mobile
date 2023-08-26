import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stake_calculator/di/app_module.dart';
import 'package:path/path.dart';

import '../data/local/shared_preference.dart';
import '../domain/cache.dart';
import '../objectbox.g.dart';

configureDependencies() async {
  final sharedPref = await SharedPreferences.getInstance();
  GetIt.instance.registerSingleton<Cache>(
      SharedPreference(sharedPreferences: sharedPref));

  // configure datastore
  final docsDir = await getApplicationDocumentsDirectory();
  GetIt.instance.registerSingleton<Store>(Store(getObjectBoxModel(),
      directory: join(docsDir.path, 'xtakee-database')));

  configureAppModule();
}
