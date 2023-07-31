import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';
import '../commons.dart';

class XButton extends StatelessWidget {
  final String label;
  final Function() onClick;
  final bool enabled;
  double? height;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;

  XButton(
      {super.key,
      this.height,
      required this.label,
      required this.onClick,
      this.backgroundColor = primaryColor,
      this.margin,
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
          child: Text(
            label,
            textScaleFactor: scale,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
