import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/core/widget/xstate.dart';
import 'package:stake_calculator/domain/model/notification.dart' as xnot;
import 'package:stake_calculator/ui/notifications/component/render/text_render.dart';

class NotificationRender extends StatefulWidget {
  final xnot.Notification notification;

  const NotificationRender({super.key, required this.notification});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends XState<NotificationRender> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: _getType(widget.notification),
          ),
        ),
      );

  Widget _getType(xnot.Notification notification) {
    switch (notification.type) {
      case 'text':
        return TextRender(notification: notification);
      default:
        return Container();
    }
  }
}
