import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../../util/dimen.dart';
import '../../commons.dart';
import '../../core/xcard.dart';

enum Processor { paystack, flutterwave }

class PaymentProcessor extends StatelessWidget {
  final Function(Processor processor) onSelected;

  const PaymentProcessor({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) => Container(
        color: primaryBackground,
        padding: EdgeInsets.only(bottom: 16.h, top: 5.h),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Continue with",
              textScaleFactor: scale,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            _type(context,
                icon: Image.asset(
                  Res.flutterwave,
                  height: 24.h,
                  width: 24.w,
                  fit: BoxFit.fill,
                ),
                label: "Flutterwave",
                onTap: () => onSelected(Processor.flutterwave)),
            // _type(context,
            //     icon: Container(
            //       height: 24.h,
            //       width: 24.w,
            //       padding: EdgeInsets.only(right: 6.w, left: 3.w),
            //       child: SvgPicture.asset(
            //         Res.paystack,
            //         height: 15.h,
            //       ),
            //     ),
            //     label: "Paystack",
            //     onTap: () => onSelected(Processor.paystack))
          ],
        ),
      );

  Widget _type(BuildContext context,
          {required Widget icon,
          required String label,
          required Function() onTap}) =>
      XCard(
          elevation: 0,
          margin: EdgeInsets.only(top: 5.h),
          onTap: () {
            AppRouter.goBack(context);
            onTap();
          },
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 5.w,
                  ),
                  icon,
                  Container(
                    height: 24.h,
                    color: primaryBackground,
                    width: 1.h,
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                  ),
                  Text(
                    label,
                    textScaleFactor: scale,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  )
                ],
              ),
              const Icon(Icons.chevron_right)
            ],
          ));
}
