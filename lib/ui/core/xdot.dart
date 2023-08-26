import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';

class XDot extends StatelessWidget {
  final Color color;
  final double size;

  const XDot({super.key, this.color = Colors.black87, this.size = 10});

  @override
  Widget build(BuildContext context) => Container(
      width: size.h,
      height: size.h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}
