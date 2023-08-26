import 'package:get_it/get_it.dart';
import 'package:objectbox/objectbox.dart';
import 'package:stake_calculator/data/account_repository.dart';
import 'package:stake_calculator/data/remote/stake_service.dart';
import 'package:stake_calculator/data/remote/transaction_service.dart';
import 'package:stake_calculator/data/stake_repository.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';
import 'package:stake_calculator/domain/istake_repository.dart';
import 'package:stake_calculator/domain/itransaction_repository.dart';
import 'package:stake_calculator/domain/remote/iaccount_service.dart';
import 'package:stake_calculator/domain/inotification_repository.dart';
import 'package:stake_calculator/domain/remote/itransaction_service.dart';

import '../data/notification_repository.dart';
import '../data/remote/account_service.dart';
import '../data/transaction_repository.dart';
import '../domain/cache.dart';
import '../domain/remote/istake_service.dart';
import '../util/dio_client.dart';

void configureAppModule() {
  final cache = GetIt.instance<Cache>();
  GetIt.instance
      .registerSingleton<IStakeService>(StakeService(client: dioClient(cache)));
  final service = GetIt.instance<IStakeService>();

  GetIt.instance.registerSingleton<ITransactionService>(
      TransactionService(client: dioClient(cache)));
  final transactionService = GetIt.instance<ITransactionService>();

  final store = GetIt.instance<Store>();

  GetIt.instance.registerSingleton<IStakeRepository>(
      StakeRepository(cache: cache, service: service));

  GetIt.instance.registerSingleton<ITransactionRepository>(
      TransactionRepository(cache: cache, service: transactionService));

  GetIt.instance.registerSingleton<IAccountService>(
      AccountService(client: dioClient(cache)));

  final accountService = GetIt.instance<IAccountService>();

  GetIt.instance.registerSingleton<IAccountRepository>(
      AccountRepository(cache: cache, service: accountService));

  GetIt.instance.registerSingleton<INotificationRepository>(
      NotificationRepository(store: store));
}
