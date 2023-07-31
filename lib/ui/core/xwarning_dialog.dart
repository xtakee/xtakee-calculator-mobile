import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

class XWarningDialog extends StatelessWidget {
  final String positive;
  final String negative;
  final String title;
  final String description;

  final Function() onPositive;
  final Function() onNegative;

  const XWarningDialog(
      {super.key,
      required this.onNegative,
      required this.onPositive,
      required this.description,
      this.negative = "Cancel",
      required this.positive,
      required this.title});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
            Container(
              height: 16.h,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            ),
            Container(
              height: 24.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    AppRouter.goBack(context);
                    onPositive();
                  },
                  child: Text(
                    positive,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 16.sp),
                  ),
                ),
                Container(
                  width: 24.w,
                ),
                GestureDetector(
                  onTap: () {
                    AppRouter.goBack(context);
                    onNegative();
                  },
                  child: Text(negative,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 16.sp)),
                )
              ],
            )
          ],
        ),
      );
}
