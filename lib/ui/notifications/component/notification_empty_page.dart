import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../../res.dart';

class NotificationEmptyPage extends StatelessWidget {
  final String title;
  final String body;

  const NotificationEmptyPage(
      {super.key, this.title = 'You don\'t have any notifications',
      this.body = 'All notifications will appear here'});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Res.ic_notify),
          SizedBox(height: 50.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}
