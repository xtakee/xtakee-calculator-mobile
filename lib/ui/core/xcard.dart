import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';

class XCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color backgroundColor;
  final BorderSide borderSide;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  Function()? onTap;

  XCard(
      {super.key,
      this.onTap,
      required this.child,
      this.borderSide = BorderSide.none,
      this.elevation = 2,
      this.backgroundColor = Colors.white,
      this.padding,
      this.margin});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        child: Card(
          elevation: elevation,
          color: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), side: borderSide),
          child: Container(
            padding: padding ?? EdgeInsets.all(5.h),
            constraints: const BoxConstraints(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: backgroundColor,
            ),
            child: child,
          ),
        ),
      ));
}
