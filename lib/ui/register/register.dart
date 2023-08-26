import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stake_calculator/domain/model/phone.dart';
import 'package:stake_calculator/ui/core/xdialog.dart';
import 'package:stake_calculator/ui/register/component/register_success.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../res.dart';
import '../../util/process_indicator.dart';
import '../commons.dart';
import '../core/xbutton.dart';
import '../core/xfooter.dart';
import '../core/xtext_field.dart';
import 'bloc/register_bloc.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Register> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final ProcessIndicator _processIndicator = ProcessIndicator();

  final _bloc = RegisterBloc();

  @override
  void dispose() {
    _bloc.close();
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
      bloc: _bloc,
      builder: (_, RegisterState state) {
        return Material(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned.fill(
                  child: Scaffold(
                backgroundColor: Colors.white,
                //resizeToAvoidBottomInset: false,
                appBar: AppBar(
                    backgroundColor: Colors.white,
                    forceMaterialTransparency: true),
                body: SafeArea(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SingleChildScrollView(
                      child: _page(),
                    ),
                  ),
                ),
              )),
              Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(Res.light_asset_bg, height: 128.h)),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Opacity(
                    opacity: 0.3,
                    child: SvgPicture.asset(
                      Res.intro_background,
                      height: 200,
                    ),
                  )),
            ],
          ),
        );
      },
      listener: (_, RegisterState state) {
        if (state.loading) {
          _processIndicator.show(context);
        } else if (state.success) {
          _processIndicator.dismiss().then((value) =>
              XDialog(context, child: const RegisterSuccess()).show());
        } else {
          _processIndicator.dismiss();
        }

        if (state.error?.isNotEmpty == true) {
          _processIndicator.dismiss(force: true).then((value) {
            showSnack(context,
                message: state.error ?? "An unknown error occurred",
                snackType: SnackType.ERROR);
          });
        }
      });

  Widget _page() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            Res.logo,
            height: 32.h,
          ),
          Container(
            height: 16.h,
          ),
          Text(
            "Create Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp),
          ),
          Text(
            "You are almost done. Kindly create an account to get started",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
          ),
          _form(),
          Container(
            margin: EdgeInsets.only(top: 16.h),
            alignment: Alignment.center,
            child: const XFooter(),
          )
        ],
      );

  Widget _form() => BlocBuilder(
      bloc: _bloc,
      builder: (_, RegisterState state) => Container(
            margin: EdgeInsets.only(top: 32.h),
            child: Column(
              children: [
                XTextField(
                  label: "Full Name",
                  errorText: state.nameError,
                  inputType: TextInputType.name,
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.account_circle_outlined),
                ),
                Container(
                  height: 16.h,
                ),
                XTextField(
                    label: "Email Address",
                    errorText: state.emailError,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    controller: _emailController),
                Container(
                  height: 16.h,
                ),
                XTextField(
                    label: "Phone Number",
                    errorText: state.phoneError,
                    inputType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone),
                    controller: _phoneController),
                Container(
                  height: 16.h,
                ),
                XTextField(
                    label: "Password",
                    errorText: state.passwordError,
                    inputType: TextInputType.text,
                    isSecret: true,
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    controller: _passwordController),
                XButton(
                    margin: EdgeInsets.only(top: 32.h, bottom: 16.h),
                    label: "Sign Up",
                    onClick: () => _bloc.register(
                        name: _nameController.text,
                        password: _passwordController.text,
                        email: _emailController.text,
                        phone: Phone(number: _phoneController.text)))
              ],
            ),
          ));
}
