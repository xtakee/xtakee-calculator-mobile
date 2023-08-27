import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/ui/core/xbutton.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../../res.dart';
import '../../../util/route_utils/app_router.dart';
import '../../commons.dart';

class SetupAccount extends StatelessWidget {
  final Function() onOk;
  final Function() onDefault;

  const SetupAccount({super.key, required this.onOk, required this.onDefault});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Lottie.asset(Res.welcome, repeat: false),
            const Text(
              "Setup Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Container(
              height: 10.h,
            ),
            Text(
              "One last thing! To get the best out of our calculator, we recommend setting up your account to ensure best results",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
            ),
            XButton(
              margin: EdgeInsets.only(top: 32.h, left: 48.w, right: 48.w),
              label: "Go to Setting",
              height: 45.h,
              onClick: () {
                AppRouter.goBack(context);
                onOk();
              },
            ),
            GestureDetector(
              onTap: () {
                AppRouter.goBack(context);
                onDefault();
              },
              child: Container(
                margin: EdgeInsets.only(top: 24.h, bottom: 10.h),
                child: const Text(
                  "Use Default Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      );
}
