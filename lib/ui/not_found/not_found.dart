import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/create_stake/create_stake.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../res.dart';
import '../../util/dimen.dart';

class NotFound extends StatefulWidget {
  const NotFound({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Lottie.asset(Res.licence_lock),
                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Column(
                      children: [
                        Text(
                          "You need a valid licence. Kindly enter your licence key to continue",
                          textScaleFactor: scale,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 32,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppRouter.gotoWidget(const CreateStake(), context,
                                clearStack: true);
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Enter Licence",
                              textScaleFactor: scale,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          height: 32.h,
                        ),
                        GestureDetector(
                          child: RichText(
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            text: const TextSpan(
                                text: "Don't have a licence? ",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 16),
                                children: [
                                  TextSpan(
                                      text: "Create",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600))
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Powered by ",
                      textScaleFactor: scale,
                      style: const TextStyle(fontSize: 14),
                    ),
                    SvgPicture.asset(
                      Res.logo_with_name,
                      width: 64,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
