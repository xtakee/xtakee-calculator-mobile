import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';
import 'package:stake_calculator/domain/model/account.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/web_launcher.dart';
import 'package:stake_calculator/ui/core/xdialog.dart';
import 'package:stake_calculator/ui/core/xwarning_dialog.dart';
import 'package:stake_calculator/ui/history/bet_history.dart';
import 'package:stake_calculator/ui/login/login.dart';
import 'package:stake_calculator/ui/payment/payment.dart';
import 'package:stake_calculator/ui/profile/profile.dart';
import 'package:stake_calculator/util/constants.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../res.dart';
import '../../util/route_utils/app_router.dart';
import '../setting/setting.dart';
import '../wallet/wallet.dart';

void _nav(BuildContext context, {required Widget widget}) {
  AppRouter.goBack(context);
  AppRouter.gotoWidget(widget, context);
}

Widget _userLoader(BuildContext context) => Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.black26,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16.h,
            width: MediaQuery.of(context).size.width * 0.5,
            margin: EdgeInsets.only(bottom: 5.h),
            color: Colors.black12,
          ),
          Container(
            height: 16.h,
            width: MediaQuery.of(context).size.width * 0.4,
            color: Colors.black38,
          )
        ],
      ),
    );

Widget _header(BuildContext context,
        {required Account account, bool loading = true}) =>
    Container(
      margin: EdgeInsets.only(right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.h,
            height: 38.h,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: const BoxDecoration(
              color: backgroundAccent,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(Res.logo),
          ),
          if (loading) _userLoader(context),
          if (!loading)
            Text(
              account.name ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          if (!loading)
            Text(
              account.email ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 16.sp),
            )
        ],
      ),
    );

class XDrawer extends StatefulWidget {
  const XDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<XDrawer> {
  final _repository = GetIt.instance<IAccountRepository>();

  bool isLoading = true;
  Account account = Account();

  @override
  void initState() {
    super.initState();
    _repository.getAccount().then((value) {
      setState(() {
        account = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 16.w, top: 48.h, bottom: 32.h),
                  child:
                      _header(context, account: account, loading: isLoading)),
              Container(
                height: 1.h,
                color: Colors.black12,
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
                  color: Colors.black12,
                  margin: EdgeInsets.only(bottom: 10.h, left: 18.w),
                ),
                ListTile(
                  title: const Text(
                    "Profile",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: const Icon(Icons.account_circle_outlined),
                  onTap: () => _nav(context, widget: const Profile()),
                ),
                ListTile(
                  title: const Text(
                    "Settings",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: const Icon(Icons.settings_outlined),
                  onTap: () => _nav(context, widget: const Setting()),
                ),
                Container(
                  height: 1.h,
                  color: Colors.black12,
                  margin: EdgeInsets.only(bottom: 10.h, left: 18.w),
                ),
                ListTile(
                  onTap: () => AppRouter.gotoWidget(
                      const WebLauncher(path: faqs), context),
                  title: const Text(
                    "FAQs",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: const Icon(Icons.help_outline_rounded),
                ),
                ListTile(
                  onTap: () => AppRouter.gotoWidget(
                      const WebLauncher(path: privacyPolicy), context),
                  title: const Text(
                    "Privacy Policy",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: const Icon(Icons.policy_outlined),
                ),
                ListTile(
                  onTap: () => _nav(context,
                      widget: const WebLauncher(path: termsAndConditions)),
                  title: const Text(
                    "Terms & Conditions",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: const Icon(Icons.warning_amber),
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
                                    const Login(), context,
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
      );
}
