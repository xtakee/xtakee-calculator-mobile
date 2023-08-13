import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stake_calculator/ui/create_stake/bloc/create_stake_bloc.dart';
import 'package:stake_calculator/ui/home/home.dart';
import 'package:stake_calculator/util/dimen.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../res.dart';
import '../../util/process_indicator.dart';
import '../commons.dart';
import '../core/xfooter.dart';
import '../core/xtext_field.dart';

class CreateStake extends StatefulWidget {
  const CreateStake({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateStake> {
  final bloc = CreateStakeBloc();
  bool canValidate = false;
  final ProcessIndicator _processIndicator = ProcessIndicator();

  final _licenceController = TextEditingController();

  @override
  void dispose() {
    bloc.close();
    _licenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocConsumer(
        listener: (context, state) {
          if (state is OnLoading) {
            _processIndicator.show(context);
          } else if (state is OnSuccess) {
            _processIndicator.dismiss().then((value) =>
                AppRouter.gotoWidget(const Home(), context, clearStack: true));
          } else if (state is OnError) {
            _processIndicator.dismiss().then((value) => showSnack(context,
                message: state.message, snackType: SnackType.ERROR));
          }
        },
        builder: (context, state) => SafeArea(
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 20.h,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
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
                                  "Enter Licence",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.sp),
                                ),
                                Text(
                                  "Enter a valid licence key to continue",
                                  textScaleFactor: widthScale,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black45),
                                ),
                                Container(
                                  height: 32.h,
                                ),
                              ],
                            ),
                            Container(
                              height: 5.h,
                            ),
                            XTextField(
                                label: "Licence",
                                lines: 7,
                                inputType: TextInputType.text,
                                onChanged: (x) {
                                  setState(() {
                                    canValidate = x.isNotEmpty;
                                  });
                                },
                                controller: _licenceController),
                            Container(
                              height: 32,
                            ),
                            GestureDetector(
                              onTap: canValidate
                                  ? () => bloc.validateLicence(
                                      licence: _licenceController.text)
                                  : null,
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: canValidate
                                        ? primaryColor
                                        : Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "Validate",
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
                            const XFooter()
                          ],
                        ),
                      )
                    ],
                  )),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 24.h,
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                  ))
            ],
          ),
        ),
        bloc: bloc,
      ),
    );
  }
}
