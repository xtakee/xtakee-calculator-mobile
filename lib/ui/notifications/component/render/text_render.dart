import 'package:flutter/material.dart';
import 'package:stake_calculator/domain/model/notification.dart' as xnot;
import 'package:timeago/timeago.dart' as timeago;
import 'package:stake_calculator/util/dxt.dart';

class TextRender extends StatelessWidget {
  final xnot.Notification notification;

  const TextRender({super.key, required this.notification});

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title ?? "",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 5.h,
            ),
            Text(notification.description ?? ""),
            if (notification.body != null)
              Container(
                height: 24.h,
              ),
            if (notification.body != null)
              Text(notification.body ?? "", style: TextStyle(fontSize: 18.sp)),
            Container(
              height: 24.h,
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
      );
}
