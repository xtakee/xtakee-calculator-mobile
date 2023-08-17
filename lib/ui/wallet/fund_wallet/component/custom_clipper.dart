import 'package:flutter/material.dart';

/// Clip widget in oval shape at right side
class XClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    double x = 0;
    double y = size.height;
    double yControlPoint = size.height * .85;
    double increment = size.width / 12;

    while (x < size.width) {
      path.quadraticBezierTo(
          x + increment / 2, yControlPoint, x + increment, y);
      x += increment;
    }

    path.lineTo(size.width, 0.0);

    while (x > 0) {
      path.quadraticBezierTo(
          x - increment / 2, size.height * .15, x - increment, 0);
      x -= increment;
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return oldClipper != this;
  }
}