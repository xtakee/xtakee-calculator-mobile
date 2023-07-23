import 'package:flutter/material.dart';

enum SnackType { ERROR, MESSAGE }

void showSnack(BuildContext context,
    {required String message, SnackType snackType = SnackType.MESSAGE}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor:
        snackType == SnackType.MESSAGE ? Colors.blue : Colors.redAccent,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

const Color primaryColor = Color(0xFF0AB7D8);
const Color primaryBackground = Color(0xFFF7F7F7);
const Color colorGreen = Color(0xFF59CE8F);
const Color colorFaintGreen = Color(0xFFf0fdf4);
const Color backgroundAccent = Color(0xFFf2feff);
