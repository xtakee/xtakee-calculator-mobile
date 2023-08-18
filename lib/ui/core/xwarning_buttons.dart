import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';
import '../../util/route_utils/app_router.dart';

class XWarningButtons extends StatelessWidget {
  final Function() onDelete;
  final Function() onWon;
  final String label;

  const XWarningButtons(
      {super.key,
      required this.onWon,
      required this.onDelete,
      this.label = "Delete"});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  AppRouter.goBack(context);
                  onWon();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: colorGreen),
                  child: Text(
                    "I Won",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppRouter.goBack(context);
                  onDelete();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  margin: EdgeInsets.only(left: 16.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red.withOpacity(0.7)),
                  child: Text(
                    label,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => AppRouter.goBack(context),
            child: Container(
              margin: EdgeInsets.only(top: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
}
