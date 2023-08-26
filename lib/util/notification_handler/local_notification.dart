import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:stake_calculator/domain/model/notification.dart';

const String PROMOTIONAL_NOTIFICATION_KEY = 'promotional_channel';
const String PROMOTIONAL_NOTIFICATION_CHANNEL = 'Promotional Notifications';

_createUniqueId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);

Future<void> showCampaignNotifications(Notification notification) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: _createUniqueId(),
          channelKey: PROMOTIONAL_NOTIFICATION_KEY,
          title: notification.title,
          payload: {"data": notification.body},
          notificationLayout: NotificationLayout.Default,
          body: notification.description ?? ''));
}

void setupNotificationChannel() {
  final promotionalChannel = NotificationChannel(
      channelKey: PROMOTIONAL_NOTIFICATION_KEY,
      channelName: PROMOTIONAL_NOTIFICATION_CHANNEL,
      channelShowBadge: true,
      onlyAlertOnce: false,
      importance: NotificationImportance.High,
      channelDescription: 'campaign');

  AwesomeNotifications()
      .initialize('resource://drawable/xtakee_icon', [promotionalChannel]);
}
