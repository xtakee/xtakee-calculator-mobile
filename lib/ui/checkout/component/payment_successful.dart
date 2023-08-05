import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../home/home.dart';

class PaymentSuccessful extends StatelessWidget {
  const PaymentSuccessful({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(Res.pay_success, repeat: false),
            const Text(
              "Payment Successful",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Container(
              height: 5.h,
            ),
            const Text(
              "We have successfully received your payment. Your coins should arrive in your wallet",
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
                  "Let's make money",
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
