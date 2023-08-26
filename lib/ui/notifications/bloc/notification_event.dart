part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class GetNotifications extends NotificationEvent {}

class DeleteNotification extends NotificationEvent {
  final Notification notification;

  DeleteNotification({required this.notification});
}

class ReadNotification extends NotificationEvent {
  final Notification notification;

  ReadNotification({required this.notification});
}
