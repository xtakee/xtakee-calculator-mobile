import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';

class XBottomSheet {
  final Widget child;
  final Color backgroundColor;
  final BuildContext context;

  XBottomSheet(this.context,
      {required this.child, this.backgroundColor = Colors.white});

  void show() {
    showModalBottomSheet(
        context: context,
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        isScrollControlled: true,
        builder: (con) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(con).viewInsets.bottom,
                  top: 16.h,
                  left: 16.w,
                  right: 16.w),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0))),
              child: child,
            ),
          );
        });
  }
}
