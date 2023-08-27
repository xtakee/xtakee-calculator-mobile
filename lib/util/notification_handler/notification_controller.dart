import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:stake_calculator/env/main_development.dart';

import '../../data/mapper/json_notification_mapper.dart';
import '../../ui/notifications/component/render/notification_render.dart';
import '../route_utils/app_router.dart';

class NotificationController {
  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    final payload = receivedAction.payload;
    if (payload != null && navigator.currentContext != null) {
      final notification = JsonNotificationMapper().from(payload);
      switch (notification.category) {
        case 'campaign':
          AppRouter.gotoWidget(NotificationRender(notification: notification),
              navigator.currentContext!);
          return;
      }
    }
  }
}
