import 'package:get_it/get_it.dart';
import 'package:stake_calculator/data/remote/service.dart';
import 'package:stake_calculator/data/repository.dart';
import 'package:stake_calculator/domain/irepository.dart';

import '../domain/cache.dart';
import '../domain/remote/IService.dart';
import '../util/dio_client.dart';

void configureAppModule() {
  final cache = GetIt.instance<Cache>();
  GetIt.instance.registerSingleton<IService>(Service(client: dioClient(cache)));
  final service = GetIt.instance<IService>();

  GetIt.instance.registerSingleton<IRepository>(
      Repository(cache: cache, service: service));
}
