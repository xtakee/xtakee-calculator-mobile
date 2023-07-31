import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xdialog.dart';
import 'package:stake_calculator/ui/core/xwarning_dialog.dart';
import 'package:stake_calculator/ui/history/bet_history.dart';
import 'package:stake_calculator/ui/not_found/not_found.dart';
import 'package:stake_calculator/ui/payment/payment.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../res.dart';
import '../../util/route_utils/app_router.dart';
import '../setting/setting.dart';
import '../wallet/wallet.dart';

void _nav(BuildContext context, {required Widget widget}) {
  AppRouter.goBack(context);
  AppRouter.gotoWidget(widget, context);
}

Drawer xDrawer(BuildContext context) => Drawer(
      backgroundColor: primaryBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 16.w, top: 48.h, bottom: 32.h),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Res.logo_with_name,
                        height: 28.h,
                      )
                    ],
                  )),
              Container(
                height: 1.h,
                color: Colors.black38,
                margin: EdgeInsets.only(bottom: 10.h, left: 18.w),
              ),
              ListTile(
                onTap: () => _nav(context, widget: const Wallet()),
                title: const Text(
                  "My Coins",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                leading: const Icon(Icons.wallet),
              ),
              ListTile(
                onTap: () => _nav(context, widget: const BetHistory()),
                title: const Text(
                  "History",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                leading: const Icon(Icons.history),
              ),
              ListTile(
                onTap: () => _nav(context, widget: const Payment()),
                title: const Text(
                  "Transactions",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                leading: const Icon(Icons.mobile_friendly_outlined),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 32.h),
            child: Column(
              children: [
                Container(
                  height: 1.h,
                  color: Colors.black38,
                  margin: EdgeInsets.only(bottom: 10.h, left: 18.w),
                ),
                ListTile(
                  title: const Text(
                    "Settings",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: const Icon(Icons.settings),
                  onTap: () => _nav(context, widget: const Setting()),
                ),
                ListTile(
                  onTap: () {},
                  title: const Text(
                    "Help",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: const Icon(Icons.help_outline_rounded),
                ),
                const ListTile(
                  title: Text(
                    "About",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.info_outline),
                ),
                Container(
                  height: 10.h,
                ),
                GestureDetector(
                  onTap: () {
                    XDialog(context,
                            child: XWarningDialog(
                                onNegative: () {},
                                onPositive: () => AppRouter.gotoWidget(
                                    const NotFound(), context,
                                    clearStack: true),
                                description:
                                    "Are you sure? You will need to provide your licence to login later",
                                positive: "Logout",
                                title: "Logout?"))
                        .show();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp),
                      ),
                      Container(
                        width: 10.w,
                      ),
                      const Icon(Icons.logout)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
