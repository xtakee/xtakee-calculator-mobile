import 'package:get_it/get_it.dart';
import 'package:stake_calculator/data/remote/service.dart';
import 'package:stake_calculator/data/remote/transaction_service.dart';
import 'package:stake_calculator/data/repository.dart';
import 'package:stake_calculator/domain/irepository.dart';
import 'package:stake_calculator/domain/itransaction_repository.dart';
import 'package:stake_calculator/domain/remote/itransaction_service.dart';

import '../data/transaction_repository.dart';
import '../domain/cache.dart';
import '../domain/remote/iservice.dart';
import '../util/dio_client.dart';

void configureAppModule() {
  final cache = GetIt.instance<Cache>();
  GetIt.instance.registerSingleton<IService>(Service(client: dioClient(cache)));
  final service = GetIt.instance<IService>();

  GetIt.instance.registerSingleton<ITransactionService>(
      TransactionService(client: dioClient(cache)));
  final transactionService = GetIt.instance<ITransactionService>();

  GetIt.instance.registerSingleton<IRepository>(
      Repository(cache: cache, service: service));

  GetIt.instance.registerSingleton<ITransactionRepository>(
      TransactionRepository(cache: cache, service: transactionService));
}
