import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';
import '../commons.dart';

class XButton extends StatelessWidget {
  final String label;
  final Function() onClick;
  final bool enabled;
  final EdgeInsetsGeometry? margin;

  const XButton(
      {super.key,
      required this.label,
      required this.onClick,
      this.margin,
      this.enabled = true});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => enabled ? onClick() : null,
        child: Container(
          height: 50.h,
          margin: margin,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: enabled ? primaryColor : Colors.black12,
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
