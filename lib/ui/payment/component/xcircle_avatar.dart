import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/util/dxt.dart';

class XCircleAvatar extends StatelessWidget {
  final Color backgroundColor;

  const XCircleAvatar({super.key, this.backgroundColor = colorGreen});

  @override
  Widget build(BuildContext context) => Container(
        width: 38.h,
        height: 38.h,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        alignment: Alignment.center,
        child: Text(
          "#",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 18.sp),
        ),
      );
}
