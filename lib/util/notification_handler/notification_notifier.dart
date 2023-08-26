import 'package:flutter/material.dart';
import 'package:stake_calculator/domain/model/notification.dart' as xnot;

class NotificationNotifier with ChangeNotifier {
  xnot.Notification? _notification;

  xnot.Notification get notification => _notification ?? xnot.Notification();

  set notification(xnot.Notification value) {
    _notification = value;
    notify();
  }

  notify() => notifyListeners();
}

NotificationNotifier notificationNotifier = NotificationNotifier();
