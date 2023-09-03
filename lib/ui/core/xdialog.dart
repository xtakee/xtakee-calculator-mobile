import 'package:flutter/material.dart';

class XDialog {
  final BuildContext context;
  final Widget child;
  final bool dismissible;

  XDialog(this.context, {this.dismissible = false, required this.child});

  show() => showDialog(
      context: context,
      builder: (_) => WillPopScope(
          child: Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: IntrinsicHeight(child: child)),
          onWillPop: () async => false),
      barrierDismissible: dismissible);
}
