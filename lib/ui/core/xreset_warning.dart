import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/core/xwarning_buttons.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';

class XResetWarning extends StatelessWidget {
  final Function() onReset;
  final Function() onWon;

  const XResetWarning({super.key, required this.onWon, required this.onReset});

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            RichText(
              softWrap: true,
              textScaleFactor: scale,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Reset Rounds\n\n",
                  style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                        text:
                            "This will reset your rounds. Kindly tell us why.\n",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    TextSpan(
                        text: "Please note this is not reversible",
                        style: TextStyle(
                            color: Colors.redAccent.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ]),
            ),
            Container(
              height: 24.h,
            ),
            XWarningButtons(
              onDelete: () => onReset(),
              onWon: () => onWon(),
              label: "Reset",
            ),
            Container(
              height: 24.h,
            )
          ],
        ),
      );
}

/*

 */
