import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget xShimmer({required Widget child}) => Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.black26,
      enabled: true,
      child: child,
    );
