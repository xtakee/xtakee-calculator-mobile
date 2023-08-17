import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/ui/login/login.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../../res.dart';
import '../../../util/route_utils/app_router.dart';
import '../../commons.dart';

class PasswordResetSuccess extends StatelessWidget {
  const PasswordResetSuccess({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(Res.pay_success),
            const Text(
              "You're all set",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Container(
              height: 5.h,
            ),
            const Text(
              "You have successfully reset your password. You can now login with your new password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Container(
              height: 32.h,
            ),
            GestureDetector(
              onTap: () => AppRouter.gotoWidget(const Login(), context,
                  clearStack: true),
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.w),
                child: const Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
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
