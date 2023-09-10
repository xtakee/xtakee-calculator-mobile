import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../../util/route_utils/app_router.dart';
import '../../commons.dart';

class SettingWarning extends StatelessWidget {
  final String title;
  final Widget description;
  final Function() onOk;

  const SettingWarning(
      {super.key,
      required this.description,
      required this.title,
      required this.onOk});

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
            Container(
              margin: EdgeInsets.only(top: 24.h, bottom: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      AppRouter.goBack(context);
                      onOk();
                    },
                    child: const Text(
                      "Ok",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.redAccent),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => AppRouter.goBack(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
}
