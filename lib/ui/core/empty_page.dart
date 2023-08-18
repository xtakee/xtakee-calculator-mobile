import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';
import '../commons.dart';

class EmptyPage extends StatelessWidget {
  final String description;
  final String ctaLabel;

  final Function() onClicked;

  const EmptyPage(
      {super.key,
      required this.description,
      required this.ctaLabel,
      required this.onClicked});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: (MediaQuery.of(context).size.height * 0.2).h),
          Text(
            description,
            style: TextStyle(fontSize: 18.sp),
          ),
          Container(
            height: 16.h,
          ),
        ],
      );
}
