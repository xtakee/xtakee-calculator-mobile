import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xbutton.dart';
import 'package:stake_calculator/ui/core/xtext_field.dart';
import 'package:stake_calculator/ui/create_stake/create_stake.dart';
import 'package:stake_calculator/ui/forgot_password/forgot_password.dart';
import 'package:stake_calculator/ui/home/home.dart';
import 'package:stake_calculator/ui/login/bloc/login_bloc.dart';
import 'package:stake_calculator/ui/register/register.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../res.dart';
import '../../util/dimen.dart';
import '../../util/process_indicator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ProcessIndicator _processIndicator = ProcessIndicator();

  final _bloc = LoginBloc();

  final coffee = Emoji('wave', '👋');

  @override
  void initState() {
    super.initState();
    _bloc.resetCache();
    _bloc.setOnboarded();
  }

  @override
  void dispose() {
    _bloc.close();
    _processIndicator.dismiss();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
      bloc: _bloc,
      builder: (_, LoginState state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(Res.light_asset_bg, height: 128.h)),
              Positioned(
                  top: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.3,
                    child: SvgPicture.asset(
                      Res.intro_background,
                      height: 128.h,
                    ),
                  )),
              Positioned(
                  top: 48.h,
                  left: 16.w,
                  right: 16.w,
                  bottom: 0,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: _page(),
                    ),
                  ))
            ],
          ),
        );
      },
      listener: (_, LoginState state) {
        if (state.loading) {
          _processIndicator.show(context);
        } else if (state.success) {
          _processIndicator.dismiss().then((value) =>
              AppRouter.gotoWidget(const Home(), context, clearStack: true));
        } else {
          _processIndicator.dismiss();
        }

        if (state.error?.isNotEmpty == true) {
          _processIndicator.dismiss(force: true).then((value) {
            showSnack(context,
                message: state.error ?? "", snackType: SnackType.ERROR);
          });
        }
      });

  Widget _page() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                Res.logo,
                height: 32.h,
              ),
              Container(
                height: 16.h,
              ),
              Text(
                "Welcome Back${coffee.code}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.sp),
              ),
              Text(
                "Kindly login to continue",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
              ),
              _form(),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 1.h,
                    color: primaryBackground,
                    margin: EdgeInsets.only(right: 10.w),
                  )),
                  Text(
                    "OR",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
                  ),
                  Expanded(
                      child: Container(
                          height: 1.h,
                          color: primaryBackground,
                          margin: EdgeInsets.only(left: 10.w)))
                ],
              ),
              XButton(
                  margin: EdgeInsets.only(top: 16.h),
                  label: "Enter a licence key",
                  //textColor: Colors.black,
                  backgroundColor: Colors.black45,
                  onClick: () =>
                      AppRouter.gotoWidget(const CreateStake(), context)),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 32.h, bottom: 16.h),
            alignment: Alignment.center,
            child: _create(),
          )
        ],
      );

  Widget _create() => GestureDetector(
        onTap: () => AppRouter.gotoWidget(const Register(), context),
        child: RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: Colors.black45, fontSize: 16.sp),
              children: const [
                TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600))
              ]),
        ),
      );

  Widget _form() => BlocBuilder(
      bloc: _bloc,
      builder: (_, LoginState state) {
        return Container(
          margin: EdgeInsets.only(top: 32.h),
          child: Column(
            children: [
              XTextField(
                label: "Email Address",
                errorText: state.emailError,
                inputType: TextInputType.emailAddress,
                controller: _emailController,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              Container(
                height: 16.h,
              ),
              XTextField(
                  label: "Password",
                  isSecret: true,
                  errorText: state.passwordError,
                  inputType: TextInputType.text,
                  prefixIcon: const Icon(Icons.lock_outline_sharp),
                  controller: _passwordController),
              Container(
                height: 16.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () =>
                        AppRouter.gotoWidget(const ForgotPassword(), context),
                    child: Text("Forgot Password?",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w300)),
                  )
                ],
              ),
              XButton(
                  margin: EdgeInsets.only(top: 32.h, bottom: 16.h),
                  label: "Login",
                  onClick: () => _bloc.login(
                      password: _passwordController.text,
                      email: _emailController.text))
            ],
          ),
        );
      });
}
