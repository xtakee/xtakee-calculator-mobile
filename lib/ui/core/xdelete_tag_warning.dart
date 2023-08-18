import 'package:flutter/material.dart';
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/ui/core/xwarning_buttons.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';

class XDeleteTagWarning extends StatelessWidget {
  final Function(Odd odd, int position) onDelete;
  final Function(Odd odd, int position) onWon;
  final Odd tag;
  final int position;

  const XDeleteTagWarning(
      {super.key,
      required this.onWon,
      required this.onDelete,
      required this.tag,
      required this.position});

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            RichText(
              softWrap: true,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Delete ",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: "${tag.name}?\n\n",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900)),
                    TextSpan(
                        text:
                            "You are about to delete a tag. Kindly tell us why.\n",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp)),
                    TextSpan(
                        text: "Please note this is not reversible",
                        style: TextStyle(
                            color: Colors.redAccent.withOpacity(0.5),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold))
                  ]),
            ),
            Container(
              height: 24.h,
            ),
            XWarningButtons(
              onDelete: () => onDelete(tag, position),
              onWon: () => onWon(tag, position),
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
