import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../../util/dimen.dart';

class EmptyHistoryPage extends StatelessWidget {
  final String text;
  const EmptyHistoryPage({super.key, this.text = "You have not made any bet"});


  @override
  Widget build(BuildContext context) =>
      Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.7,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.3,
              child: SizedBox(
                height: 200.h,
                child: Lottie.asset(Res.empty),
              ),
            ),
            // const Icon(Icons.file_copy, size: 72, color: primaryColor),
            Text(
              text,
              textScaleFactor: scale,
              style: const TextStyle(fontSize: 18),
            ),
            Container(
              height: 16.h,
            ),
          ],
        ),
      );
}
