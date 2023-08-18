import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/ui/core/xbutton.dart';
import 'package:stake_calculator/ui/core/xtext_field.dart';
import 'package:stake_calculator/ui/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:stake_calculator/ui/otp_verification/otp_verification.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../commons.dart';
import '../core/widget/XState.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends XState<ForgotPassword> {
  final _emailController = TextEditingController();
  final _bloc = ForgotPasswordBloc();

  @override
  void dispose() {
    _bloc.close();
    _emailController.dispose();
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
            "Forgot Password",
            style: TextStyle(color: Colors.black, fontSize: 18.sp),
          ),
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer(
            bloc: _bloc,
            listener: (_, ForgotPasswordState state) {
              if (state.loading) {
                showProcessIndicator();
              } else {
                dismissProcessIndicator().then((_) {
                  if (state.error?.isNotEmpty == true) {
                    showMessage(
                        message: state.error!, snackType: SnackType.ERROR);
                  }

                  if (state.success) {
                    AppRouter.gotoWidget(
                        OtpVerification(
                          emailAddress: _emailController.text,
                        ),
                        context);
                  }
                });
              }
            },
            builder: (_, ForgotPasswordState state) => SafeArea(
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
                            Lottie.asset(Res.forgot_password,
                                height: 180.h, repeat: false)
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 24.h),
                            child: Column(
                              children: [
                                Text(
                                  "Kindly enter your email address to receive a one time password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16.sp, color: Colors.black87),
                                ),
                                Container(
                                  height: 48.h,
                                ),
                                XTextField(
                                    label: "Email Address",
                                    inputType: TextInputType.emailAddress,
                                    errorText: state.emailError,
                                    controller: _emailController),
                                Container(
                                  height: 24.h,
                                ),
                                GestureDetector(
                                  onTap: () => AppRouter.goBack(context),
                                  child: Text("Try another way",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: primaryColor,
                                          decoration: TextDecoration.underline,
                                          decorationColor: primaryColor,
                                          decorationStyle:
                                              TextDecorationStyle.solid)),
                                ),
                                Container(
                                  height: 32.h,
                                ),
                                XButton(
                                    label: "Send",
                                    onClick: () => _bloc.requestOtp(
                                        email: _emailController.text)),
                                Container(
                                  height: 24.h,
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                )),
      );
}
