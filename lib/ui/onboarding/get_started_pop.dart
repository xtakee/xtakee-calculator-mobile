import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../res.dart';
import '../../util/route_utils/app_router.dart';
import '../commons.dart';

class GetStartedPop extends StatelessWidget {
  const GetStartedPop({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(Res.welcome, repeat: false),
        const Text(
          "What we offer",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          height: 5.h,
        ),
        const Text(
          "Before you get started, we highly recommend you watch our instructional contents for a better understanding of how xtakee works and what to expect",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        Container(
          height: 32.h,
        ),
        GestureDetector(
          onTap: ()=> AppRouter.goBack(context),
          child: Container(
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10)
            ),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 24.w),
            child: const Text(
              "Let's go",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        Container(
          height: 32.h,
        ),
      ],
    ),
  );
}