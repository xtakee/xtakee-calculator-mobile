import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stake_calculator/ui/core/widget/xstate.dart';
import 'package:stake_calculator/ui/notifications/component/render/notification_render.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/notification_handler/notification_notifier.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import 'bloc/notification_bloc.dart';
import 'component/notification_empty_page.dart';
import 'component/notification_item.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends XState<Notifications> {
  final _bloc = NotificationBloc();

  @override
  void initState() {
    super.initState();
    notificationNotifier.addListener(() {
      _bloc.getNotifications();
    });
    _bloc.getNotifications();
  }

  @override
  void dispose() {
    _bloc.close();
    notificationNotifier.removeListener(() {});
    super.dispose();
  }

  itemSeparator() => Container(
        color: const Color(0xFFF0F0F0),
        margin: EdgeInsets.only(left: 70.w),
        height: 1.h,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text(
            "Notifications",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer(
          bloc: _bloc,
          listener: (_, NotificationState state) {},
          builder: (_, NotificationState state) {
            return SafeArea(
                child: state.notifications!.isEmpty
                    ? const NotificationEmptyPage()
                    : ListView.separated(
                        itemCount: state.notifications!.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                _bloc.setRead(
                                    notification: state.notifications![index]);

                                notificationNotifier.notification =
                                    state.notifications![index];

                                AppRouter.gotoWidget(
                                        NotificationRender(
                                            notification:
                                                state.notifications![index]),
                                        context)
                                    .then((_) {
                                  setState(() {});
                                });
                              },
                              child: NotificationItem(
                                onDelete: (x) {
                                  _bloc.deleteNotification(notification: x);
                                  notificationNotifier.notification = x;
                                },
                                notification: state.notifications![index],
                              ));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            itemSeparator(),
                      ));
          },
        ),
      );
}
