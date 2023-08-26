part of 'notification_bloc.dart';

class NotificationState {
  List<Notification>? notifications;

  NotificationState({this.notifications});

  NotificationState copy({List<Notification>? notifications}) =>
      NotificationState(notifications: notifications ?? this.notifications);
}
