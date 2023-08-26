import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/core/web_launcher.dart';
import 'package:stake_calculator/ui/core/xdot.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/constants.dart';
import '../../util/route_utils/app_router.dart';

class XFooter extends StatelessWidget {
  const XFooter({super.key});

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
            onTap: () => AppRouter.gotoWidget(
                const WebLauncher(path: termsAndConditions), context),
            child: Text(
              "Terms & Conditions",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            )),
        Container(
          width: 10.w,
        ),
        const XDot(),
        Container(
          width: 10.w,
        ),
        GestureDetector(
            onTap: () => AppRouter.gotoWidget(
                const WebLauncher(path: privacyPolicy), context),
            child: Text("Privacy",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: Colors.black87))),
        Container(
          width: 10.w,
        ),
        const XDot(),
        Container(
          width: 10.w,
        ),
        GestureDetector(
          onTap: () =>
              AppRouter.gotoWidget(const WebLauncher(path: faqs), context),
          child: Text(
            "FAQs",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: Colors.black87),
          ),
        )
      ]);
}
