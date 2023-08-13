import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';
import '../commons.dart';

class XButton extends StatelessWidget {
  final String label;
  final Function() onClick;
  final bool enabled;
  final bool loading;
  double? height;
  final Color textColor;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;

  XButton(
      {super.key,
      this.height,
      this.textColor = Colors.white,
      required this.label,
      required this.onClick,
      this.backgroundColor = primaryColor,
      this.margin,
      this.loading = false,
      this.enabled = true}) {
    height = height ?? 50.h;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => enabled ? onClick() : null,
        child: Container(
          height: height,
          margin: margin,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: enabled ? backgroundColor : Colors.black12,
              borderRadius: BorderRadius.circular(10)),
          child: loading
              ? Transform.scale(
                  scale: 1.5,
                  child: Lottie.asset(Res.linear_loader),
                )
              : Text(
                  label,
                  textScaleFactor: scale,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
        ),
      );
}
