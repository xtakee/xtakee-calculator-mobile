import 'package:flutter/material.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xcard.dart';
import 'package:stake_calculator/ui/payment/component/xcircle_avatar.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/formatter.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) => XCard(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      backgroundColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              children: [
                XCircleAvatar(
                  backgroundColor: transaction.status!.toColor(),
                ),
                Container(
                  width: 10.w,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.description!.toTitleCase(),
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        transaction.reference!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(width: 16.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatter.format((transaction.amount ?? 0) * 1),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                transaction.createdAt!.toDate(),
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey),
              ),
              Text(
                "${transaction.status}",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: transaction.status!.toColor()),
              )
            ],
          )
        ],
      ));
}
