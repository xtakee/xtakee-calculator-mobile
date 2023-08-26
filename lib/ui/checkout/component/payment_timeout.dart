import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../../util/route_utils/app_router.dart';
import '../../commons.dart';
import '../../home/home.dart';

class PaymentTimeout extends StatelessWidget {
  const PaymentTimeout({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    child: Column(
      children: [
        Lottie.asset(Res.pay_failed, repeat: false, height: 128.h),
        const Text(
          "Payment Failed",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          height: 5.h,
        ),
        const Text(
          "We are not able to complete your transaction at this time. Kindly wait a while then try again.",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        Container(
          height: 32.h,
        ),
        GestureDetector(
          onTap: ()=> AppRouter.gotoWidget(const Home(), context, clearStack: true),
          child: Container(
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10)
            ),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            child: const Text(
              "Return Home",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );

}