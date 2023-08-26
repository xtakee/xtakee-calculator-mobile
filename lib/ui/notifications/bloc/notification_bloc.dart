import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:stake_calculator/domain/model/notification.dart';
import 'package:stake_calculator/domain/inotification_repository.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final _notificationRepository = GetIt.instance<INotificationRepository>();

  void getNotifications() => add(GetNotifications());

  void deleteNotification({required Notification notification}) =>
      add(DeleteNotification(notification: notification));

  NotificationBloc() : super(NotificationState(notifications: [])) {
    on<NotificationEvent>((event, emit) {
      final notifications = _notificationRepository.getNotifications();

      if (notifications.length > 1) {
        notifications.sort((a, b) {
          return b.createdAt!.compareTo(a.createdAt!);
        });
      }

      emit(state.copy(notifications: notifications));
    });

    on<DeleteNotification>((event, emit) {
      _notificationRepository.delete(notification: event.notification);
      final notifications = _notificationRepository.getNotifications();
      emit(state.copy(notifications: notifications));
    });
  }
}
