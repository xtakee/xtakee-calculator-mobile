import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum SnackType { ERROR, MESSAGE }

void showSnack(BuildContext context,
    {required String message, SnackType snackType = SnackType.MESSAGE}) {
  Flushbar(
          title: snackType == SnackType.MESSAGE ? "Message" : "Error",
          message: message,
          leftBarIndicatorColor:
              snackType == SnackType.MESSAGE ? Colors.blue : Colors.redAccent,
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP)
      .show(context);
}

const Color primaryColor = Color(0xFF0AB7D8);
const Color primaryBackground = Color(0xFFF7F7F7);
const Color primaryBackgroundAccent = Color.fromRGBO(222, 231, 240, .57);
const Color colorGreen = Color(0xFF59CE8F);
const Color colorFaintGreen = Color(0xFFf0fdf4);
const Color backgroundAccent = Color(0xFFf2feff);
