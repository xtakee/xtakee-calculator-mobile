import 'package:flutter/material.dart';
import 'package:stake_calculator/util/log.dart';

const double _height = 780;
const double _width = 392;

double heightScale = 1.0;
double widthScale = 1.0;
double scale = 1.0;
double scaleFactor = 1.0;

double getHeight(double height) => height / heightScale;

double getWidth(double width) => width / widthScale;

void setScale(Size size) {
  widthScale = _width / size.width;
  heightScale = _height / size.height;
  scale = widthScale;
  scaleFactor = widthScale / heightScale;
}
