import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/core/xcard.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../res.dart';
import '../../util/dimen.dart';
import '../commons.dart';

class PaymentMethod extends StatelessWidget {
  final Function() onSelected;

  const PaymentMethod({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Method",
              textScaleFactor: scale,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (_, index) => _method(context, index == 1))
          ],
        ),
      );

  Widget _method(BuildContext context, bool selected) => XCard(
      elevation: 0,
      margin: EdgeInsets.only(top: 8.h),
      onTap: () {
        onSelected();
        AppRouter.goBack(context);
      },
      backgroundColor: primaryBackground,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                Res.master_card,
                height: 24.h,
              ),
              Container(
                height: 24.h,
                color: primaryBackground,
                width: 1.h,
                margin: EdgeInsets.only(right: 16.w),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Master Card",
                    textScaleFactor: scale,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Text(
                    "*********** 2389",
                    textScaleFactor: scale,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  )
                ],
              )
            ],
          ),
          Radio(
            value: selected,
            groupValue: true,
            onChanged: (x) {},
            activeColor: primaryColor,
          )
        ],
      ));
}
