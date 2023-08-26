import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stake_calculator/domain/model/notification.dart'
    as xnotification;
import 'package:stake_calculator/util/dxt.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../res.dart';
import '../../commons.dart';
import '../../core/xdot.dart';

class NotificationItem extends StatelessWidget {
  final xnotification.Notification notification;
  final Function(xnotification.Notification notification) onDelete;

  const NotificationItem(
      {super.key, required this.notification, required this.onDelete});

  @override
  Widget build(BuildContext context) => Slidable(
      key: ValueKey(notification.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () => onDelete(notification)),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(notification),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFFE4A49),
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
        color: notification.read ? Colors.white : backgroundAccent,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16.w),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12.w),
                        child: SvgPicture.asset(Res.ic_bell),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title ?? "",
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    notification.description!,
                                    maxLines: 3,
                                    //overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.black),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!notification.read)
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 5.5.w,
                      child: const XDot(
                        size: 5,
                        color: primaryColor,
                      ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  timeago.format(notification.createdAt ?? DateTime.now()),
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ));
}
