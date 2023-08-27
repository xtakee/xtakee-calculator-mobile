import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/ui/core/xbutton.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

class RequestNotificationPermission extends StatelessWidget {
  const RequestNotificationPermission({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => AppRouter.goBack(context),
                  child: const Icon(Icons.close),
                )
              ],
            ),
            Lottie.asset(Res.notification_permission,
                repeat: false, height: 180.h),
            Text(
              "🔔 Enable Notifications! 🔔",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            Container(
              height: 10.h,
            ),
            Text(
              "We want to keep you informed about the latest tips and updates. Kindly grant us permission to send notifications.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp),
            ),
            XButton(
              label: "Enable",
              margin: EdgeInsets.only(
                  left: 32.w, right: 32.w, top: 24.h, bottom: 16.h),
              onClick: () => FirebaseMessaging.instance
                  .requestPermission(alert: true)
                  .then((_) => AppRouter.goBack(context)),
              height: 45.h,
            ),
          ],
        ),
      );
}
