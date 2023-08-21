import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:stake_calculator/domain/iaccount_repository.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/ui/core/widget/XState.dart';
import 'package:stake_calculator/ui/core/xbutton.dart';
import 'package:stake_calculator/ui/reset_password/reset_password.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../commons.dart';

class OtpVerification extends StatefulWidget {
  final String emailAddress;

  const OtpVerification({super.key, required this.emailAddress});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends XState<OtpVerification> {
  final _accountRepository = GetIt.instance<IAccountRepository>();
  final _controller = TextEditingController();
  final focusNode = FocusNode();
  bool canProceed = false;

  final _defaultPinTheme = PinTheme(
    width: 56.w,
    height: 60.h,
    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.sp),
    decoration: const BoxDecoration(
      color: primaryBackground,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Verify Email Address",
            style: TextStyle(color: Colors.black, fontSize: 18.sp),
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 16.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(Res.verify_email, height: 180.h, repeat: false)
                  ],
                ),
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                    child: Column(
                      children: [
                        Text(
                          "Kindly enter a one time password sent to:",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black54),
                        ),
                        Container(
                          height: 5.h,
                        ),
                        Text(
                          widget.emailAddress,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 48.h,
                        ),
                        Pinput(
                            controller: _controller,
                            focusNode: focusNode,
                            defaultPinTheme: _defaultPinTheme,
                            obscureText: true,
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsUserConsentApi,
                            listenForMultipleSmsOnAndroid: true,
                            separatorBuilder: (index) =>
                                const SizedBox(width: 8),
                            validator: (value) {},
                            onClipboardFound: (value) {
                              _controller.setText(value);
                            },
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) {},
                            onChanged: (value) {
                              setState(() {
                                canProceed = value.length == 4;
                              });
                            },
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  width: 22,
                                  height: 1,
                                  color: primaryColor,
                                ),
                              ],
                            )),
                        Container(
                          height: 32.h,
                        ),
                        XButton(
                            label: "Continue",
                            enabled: canProceed,
                            onClick: () => AppRouter.gotoWidget(
                                ResetPassword(
                                  otp: _controller.text,
                                ),
                                context)),
                        Container(
                          height: 24.h,
                        ),
                        _resendOtp(),
                        Container(
                          height: 24.h,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      );

  Widget _resendOtp() => GestureDetector(
        onTap: () {
          showProcessIndicator();
          _accountRepository.resendOtp().then((value) {
            dismissProcessIndicator();
          }).onError((error, stackTrace) {
            dismissProcessIndicator().then((_) {
              showMessage(
                  message: error.toString(), snackType: SnackType.ERROR);
            });
          });
        },
        child: RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: "Didn't get OTP? ",
              style: TextStyle(color: Colors.black45, fontSize: 16.sp),
              children: const [
                TextSpan(
                    text: "Send again",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w600))
              ]),
        ),
      );
}
