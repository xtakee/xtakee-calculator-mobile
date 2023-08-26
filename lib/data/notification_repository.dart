import 'package:stake_calculator/domain/model/notification.dart';
import 'package:stake_calculator/domain/inotification_repository.dart';

import '../objectbox.g.dart';

class NotificationRepository extends INotificationRepository {
  final Store store;

  NotificationRepository({required this.store});

  @override
  void delete({required Notification notification}) =>
      store.box<Notification>().remove(notification.id);

  @override
  Notification getNotification({required int id}) => store
      .box<Notification>()
      .query(Notification_.id.equals(id))
      .build()
      .find()
      .first;

  @override
  List<Notification> getNotifications() => store.box<Notification>().getAll();

  @override
  void save({required Notification notification}) {
    store.box<Notification>().put(notification);
  }

  @override
  void setRead({required Notification notification}) =>
      store.box<Notification>().put(notification..read = true);

  @override
  List<Notification> getUnread() => store
      .box<Notification>()
      .query(Notification_.read.equals(false))
      .build()
      .find();

  @override
  void clear() => store.box<Notification>().removeAll();
}
