import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/domain/model/history.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xcard.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/formatter.dart';

import '../../../res.dart';

class HistoryItem extends StatelessWidget {
  final History history;

  const HistoryItem({super.key, required this.history});

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(top: 5.h, left: 16.w, right: 16.w),
        child: XCard(
          backgroundColor: Colors.white,
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
            child: Column(
              children: [
                SizedBox(
                  height: 32.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("Tags# ",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black45,
                                  fontSize: 14)),
                          SizedBox(
                            width: 200.w,
                            child: Text(history.odds!.string(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                      if ((history.won ?? 0) > 0)
                        Lottie.asset(Res.trohpy, height: 32.h)
                    ],
                  ),
                ),
                Container(
                  color: primaryBackground,
                  margin: EdgeInsets.only(bottom: 10.h),
                  height: 1.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Container(
                          color: (history.won ?? 0) > 0
                              ? colorGreen
                              : Colors.orangeAccent,
                          margin: EdgeInsets.only(right: 10.w),
                          height: 52.h,
                          width: 5.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Formatter.format((history.amount ?? 0) * 1.0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 18)),
                            Container(
                              height: 5.h,
                            ),
                            Text("${history.createdAt?.toDate()}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                    fontSize: 14))
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.line_axis,
                                  color: Colors.black54,
                                  size: 20.h,
                                ),
                                Text(" ${history.odds?.length ?? 0}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        fontSize: 16)),
                                Container(
                                  width: 16.w,
                                ),
                                SvgPicture.asset(
                                  Res.trophy_thick,
                                  height: 16.h,
                                  color: Colors.black87,
                                ),
                                Text(" ${history.odds?.wins()}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                        Container(
                          height: 5.h,
                        ),
                        RichText(
                            text: TextSpan(
                                text: "Round: ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                    fontSize: 14),
                                children: [
                              TextSpan(text: history.round.toString())
                            ]))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
