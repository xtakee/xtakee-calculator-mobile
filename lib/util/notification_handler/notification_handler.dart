import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';
import 'package:stake_calculator/domain/mapper/remote_message_to_notification_mapper.dart';
import 'package:stake_calculator/domain/inotification_repository.dart';
import 'package:stake_calculator/util/config.dart';
import 'package:stake_calculator/util/notification_handler/notification_notifier.dart';

import 'local_notification.dart';

void setupPushNotification() {
  configureFCM();
  setupNotificationChannel();
}

void sendToken(String? token) async {
  if (token == null) {
    return;
  }

  final accountRepository = GetIt.instance<IAccountRepository>();
  accountRepository
      .updatePushToken(token: token)
      .onError((error, stackTrace) {});
}

String messageId = "";

void processNotification(RemoteMessage message) {
  if (messageId != (message.messageId ?? "")) {
    messageId = message.messageId ?? "";

    final notification = RemoteMessageToNotificationMapper().from(message);
    showCampaignNotifications(notification);

    final accountRepository = GetIt.instance<IAccountRepository>();
    accountRepository
        .ackNotification(campaign: message.data['ack'])
        .onError((error, stackTrace) {});

    final notificationRepository = GetIt.instance<INotificationRepository>();
    notificationRepository.save(
        notification: notification);

    notificationNotifier.notification = notification;
  }
}

void getFcmToken() {
  FirebaseMessaging.instance.onTokenRefresh.listen(sendToken);

  FirebaseMessaging.instance.getToken().then(sendToken);

  if (Platform.isIOS) FirebaseMessaging.instance.getAPNSToken().then(sendToken);
}

Future<void> backgroundHandler(RemoteMessage message) async {
  processNotification(message);
}

Future<void> restartHandler(RemoteMessage message) async {
  processNotification(message);
}

void configureFCM() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    processNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen(restartHandler);

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  await FirebaseMessaging.instance
      .subscribeToTopic("${Config.shared.flavor.name}-global");

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
}
