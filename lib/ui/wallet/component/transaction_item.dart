import 'package:flutter/material.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../../util/dimen.dart';

class TransactionItem extends StatelessWidget {

  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white,
    margin: EdgeInsets.only(bottom: 10.h, right: 16.w),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFe0f2f1)),
          child: const Icon(Icons.input, size: 20, color: primaryColor,),
        ),
        Expanded(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Deposit", textScaleFactor: scale, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                Text("Success", textScaleFactor: scale, style: const TextStyle(fontSize: 14),),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("+12,000 NGN", textScaleFactor: scale, style: const TextStyle(fontSize: 16, color: Colors.greenAccent),),
                Text("12 mar", textScaleFactor: scale, style: const TextStyle(fontSize: 14),),
              ],
            )
          ],
        ))
      ],
    ),
  );

}