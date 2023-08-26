import 'package:stake_calculator/domain/model/notification.dart';

abstract class INotificationRepository {
  Notification getNotification({required int id});

  void setRead({required Notification notification});

  void save({required Notification notification});

  List<Notification> getUnread();

  void delete({required Notification notification});

  void clear();

  List<Notification> getNotifications();
}
