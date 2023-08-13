import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xbutton.dart';
import 'package:stake_calculator/ui/core/xcard.dart';
import 'package:stake_calculator/ui/core/xshimmer.dart';
import 'package:stake_calculator/ui/core/xswitch.dart';
import 'package:stake_calculator/ui/core/xtext_field.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';
import '../../util/process_indicator.dart';
import 'bloc/profile_bloc.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Profile> {
  final _newTextController = TextEditingController();
  final _oldTextController = TextEditingController();
  final ProcessIndicator _processIndicator = ProcessIndicator();

  final _bloc = ProfileBloc();

  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    _bloc.getSummary();
  }

  @override
  void dispose() {
    _newTextController.dispose();
    _oldTextController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryBackground,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Profile",
            textScaleFactor: scale,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer(
          bloc: _bloc,
          listener: (_, ProfileState state) {
            if (state.loading) {
              _processIndicator.show(context);
            } else {
              _processIndicator.dismiss().then((_) {
                if (state.success) {
                  _newTextController.clear();
                  _oldTextController.clear();
                  FocusManager.instance.primaryFocus?.unfocus();

                  showSnack(context, message: "Password change successful");
                } else if (state.error != null) {
                  showSnack(context,
                      message: state.error ?? "", snackType: SnackType.ERROR);
                }
              });
            }
          },
          builder: (_, ProfileState state) => SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!state.stakeLoading && state.stakeError == null)
                          _item(
                              label: "Coins",
                              icon: Res.coins_bal,
                              value: (state.stake?.coins).toString())
                        else
                          _summaryItemLoader(),
                        Container(
                          width: 10.h,
                        ),
                        if (!state.stakeLoading && state.stakeError == null)
                          _item(
                              label: "Wins",
                              icon: Res.wins,
                              value: (state.stake?.wins).toString())
                        else
                          _summaryItemLoader(),
                      ],
                    ),
                    Container(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!state.stakeLoading && state.stakeError == null)
                          _item(
                              label: "Losses",
                              icon: Res.loss,
                              value: (state.stake?.loosed).toString())
                        else
                          _summaryItemLoader(),
                        Container(
                          width: 10.h,
                        ),
                        if (!state.stakeLoading && state.stakeError == null)
                          _item(
                              label: "Stakes",
                              icon: Res.total_bets,
                              value: (state.stake?.stakes).toString())
                        else
                          _summaryItemLoader(),
                      ],
                    ),
                    Container(
                      height: 16.h,
                    ),
                    Text(
                      "Personal Information",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black38,
                          fontSize: 14.sp),
                    ),
                    XCard(
                        elevation: 0,
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.all(16.h),
                        child: Column(
                          children: [
                            if (!state.accountLoading &&
                                state.accountError == null)
                              XTextField(
                                  enable: false,
                                  label: "Full Name",
                                  controller: TextEditingController()
                                    ..text = state.account?.name ?? "")
                            else
                              _horizontalLoader(),
                            Container(
                              height: 16.h,
                            ),
                            if (!state.accountLoading &&
                                state.accountError == null)
                              XTextField(
                                  enable: false,
                                  label: "Email Address",
                                  controller: TextEditingController()
                                    ..text = state.account?.email ?? "")
                            else
                              _horizontalLoader(),
                            Container(
                              height: 16.h,
                            ),
                            if (!state.accountLoading &&
                                state.accountError == null)
                              XTextField(
                                  enable: false,
                                  label: "Phone Number",
                                  controller: TextEditingController()
                                    ..text = state.account?.phone?.number ?? "")
                            else
                              _horizontalLoader(),
                          ],
                        )),
                    Container(
                      height: 18.h,
                    ),
                    Text(
                      "Change Password",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black38,
                          fontSize: 14.sp),
                    ),
                    XCard(
                        elevation: 0,
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.all(16.h),
                        child: Column(
                          children: [
                            XTextField(
                                label: "Old Password",
                                inputType: TextInputType.text,
                                errorText: state.oldPassError,
                                isSecret: !showPassword,
                                controller: _oldTextController),
                            Container(
                              height: 16.h,
                            ),
                            XTextField(
                                label: "New Password",
                                errorText: state.newPassError,
                                inputType: TextInputType.text,
                                isSecret: !showPassword,
                                controller: _newTextController),
                            Container(
                              height: 5.h,
                            ),
                            XSwitch(
                                label: "Show Password",
                                value: showPassword,
                                onChanged: (x) {
                                  setState(() {
                                    showPassword = x;
                                  });
                                }),
                            Container(
                              height: 16.h,
                            ),
                            XButton(
                                label: "Save Changes",
                                onClick: () => _bloc.changePassword(
                                    newPassword: _newTextController.text,
                                    oldPassword: _oldTextController.text))
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _summaryItemLoader() => XCard(
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: xShimmer(
          child: Column(
        children: [
          Container(
              width: 24.h,
              height: 24.h,
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              )),
          Container(
            height: 16.h,
            width: 48.w,
            color: Colors.black38,
            margin: EdgeInsets.symmetric(vertical: 3.h),
          ),
          Container(
            height: 12.h,
            width: 24.w,
            color: Colors.black38,
          )
        ],
      )));

  Widget _horizontalLoader() => xShimmer(
          child: Row(
        children: [
          Expanded(
              child: Container(
            height: 45.h,
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(5)),
          ))
        ],
      ));

  Widget _item(
          {required String label,
          required String icon,
          required String value}) =>
      XCard(
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
          child: Column(
            children: [
              SvgPicture.asset(
                icon,
                height: 24.h,
                color: primaryColor,
              ),
              Text(
                value,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: Colors.black38),
              )
            ],
          ));
}
