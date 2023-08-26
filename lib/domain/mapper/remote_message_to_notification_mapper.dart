import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stake_calculator/domain/model/notification.dart';
import 'package:stake_calculator/util/mapper.dart';

class RemoteMessageToNotificationMapper
    extends Mapper<RemoteMessage, Notification> {
  @override
  Notification from(RemoteMessage from) => Notification(
      type: from.data['type'],
      createdAt: from.sentTime,
      description: from.notification?.body,
      title: from.notification?.title,
      categoryId: from.data['campaignId'],
      ack: from.data['ack'],
      category: from.data['category']);

  @override
  RemoteMessage to(Notification from) {
    throw UnimplementedError();
  }
}
