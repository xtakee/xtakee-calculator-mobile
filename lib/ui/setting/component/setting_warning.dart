import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../../util/route_utils/app_router.dart';
import '../../commons.dart';

class SettingWarning extends StatelessWidget {
  final String title;
  final Widget description;

  const SettingWarning(
      {super.key, required this.description, required this.title});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Lottie.asset(Res.animation_caution, height: 128.h, repeat: false),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Container(
              height: 5.h,
            ),
            description,
            GestureDetector(
              onTap: () => AppRouter.goBack(context),
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 48.w),
                margin: EdgeInsets.only(top: 32.h),
                child: const Text(
                  "Ok",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
}
