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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        //backgroundColor: primaryColor,
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
          child: Container(
            color: Colors.white,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 32.h, bottom: 32.h),
                        child: SvgPicture.asset(Res.logo_with_name),
                      ),
                      Column(
                        children: [
                          Text(
                            "Stake Calculator",
                            textScaleFactor: widthScale,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 24),
                          ),
                          Container(
                            height: 10.h,
                          ),
                          Text(
                            "To use calculator, kindly paste a valid licence key to continue",
                            textScaleFactor: widthScale,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black45),
                          ),
                          Container(
                            height: 16.h,
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "#Licence",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 22,
                                color: Colors.grey),
                          ),
                          Text(
                            "#",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: Colors.black87),
                          )
                        ],
                      ),
                      Container(
                        height: 16,
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: _licenceController,
                        maxLines: 5,
                        onChanged: (x) {
                          setState(() {
                            canValidate = x.isNotEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                        ),
                      ),
                      Container(
                        height: 32,
                      ),
                      GestureDetector(
                        onTap: canValidate
                            ? () {
                                bloc.validateLicence(
                                    licence: _licenceController.text);
                              }
                            : null,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color:
                                  canValidate ? primaryColor : Colors.black26,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            "Validate",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bloc: bloc,
      ),
    );
  }
}
