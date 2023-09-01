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
    final exists = _getByMessageId(messageId: notification.messageId ?? "");
    if (exists != null) return;
    store.box<Notification>().put(notification);
  }

  @override
  void setRead({required Notification notification}) =>
      store.box<Notification>().put(notification..read = true);

  Notification? _getByMessageId({required String messageId}) => store
      .box<Notification>()
      .query(Notification_.messageId.equals(messageId))
      .build()
      .find()
      .firstOrNull;

  @override
  List<Notification> getUnread() => store
      .box<Notification>()
      .query(Notification_.read.equals(false))
      .build()
      .find();

  @override
  void clear() => store.box<Notification>().removeAll();
}
