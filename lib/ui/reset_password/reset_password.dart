import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xbutton.dart';
import 'package:stake_calculator/ui/core/xdialog.dart';
import 'package:stake_calculator/ui/core/xtext_field.dart';
import 'package:stake_calculator/ui/reset_password/bloc/reset_password_bloc.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';
import '../core/widget/XState.dart';
import '../core/xswitch.dart';
import 'component/password_reset_success.dart';

class ResetPassword extends StatefulWidget {
  final String otp;

  const ResetPassword({super.key, required this.otp});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends XState<ResetPassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _bloc = ResetPasswordBloc();

  bool showPassword = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bloc.close();
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
            "Reset Password",
            textScaleFactor: scale,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer(
          bloc: _bloc,
          listener: (_, ResetPasswordState state) {
            if (state.loading) {
              showProcessIndicator();
            } else {
              dismissProcessIndicator().then((_) {
                if (state.error?.isNotEmpty == true) {
                  showMessage(
                      message: state.error ?? "", snackType: SnackType.ERROR);
                }

                if (state.success) {
                  XDialog(context, child: const PasswordResetSuccess()).show();
                }
              });
            }
          },
          builder: (_, ResetPasswordState state) => SafeArea(
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
                            "Kindly enter your new and confirmed password below to continue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.black54),
                          ),
                          Container(
                            height: 48.h,
                          ),
                          XTextField(
                              label: "Password",
                              inputType: TextInputType.text,
                              isSecret: !showPassword,
                              errorText: state.newPasswordError,
                              controller: _passwordController),
                          Container(
                            height: 16.h,
                          ),
                          XTextField(
                              label: "Confirm Password",
                              isSecret: !showPassword,
                              inputType: TextInputType.text,
                              errorText: state.confirmPasswordError,
                              controller: _confirmPasswordController),
                          XSwitch(
                              label: "Show Password",
                              alignment: MainAxisAlignment.end,
                              value: showPassword,
                              onChanged: (x) {
                                setState(() {
                                  showPassword = x;
                                });
                              }),
                          Container(
                            height: 32.h,
                          ),
                          XButton(
                              label: "Save",
                              onClick: () => _bloc.resetPassword(
                                  otp: widget.otp,
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text)),
                          Container(
                            height: 24.h,
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      );
}
