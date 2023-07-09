import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';

class XCard extends StatelessWidget {
  final Widget child;
  final double elevation;

  const XCard({super.key, required this.child, this.elevation = 2});

  @override
  Widget build(BuildContext context) => Card(
        elevation: elevation,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(10.h),
          constraints: const BoxConstraints(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: child,
        ),
      );
}
