import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xswitch.dart';
import 'package:stake_calculator/ui/core/xtext_field.dart';
import 'package:stake_calculator/ui/home/home.dart';
import 'package:stake_calculator/ui/setting/bloc/setting_bloc.dart';
import 'package:stake_calculator/util/expandable_panel.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import 'package:stake_calculator/util/dxt.dart';
import '../../util/process_indicator.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<Setting> {
  bool restrictRounds = false;
  bool forfeitLosses = false;
  bool decay = false;
  bool clearLosses = false;
  bool multiStake = false;

  final ProcessIndicator _processIndicator = ProcessIndicator();
  final _bloc = SettingBloc();

  String? session;

  final _profitController = TextEditingController();
  final _toleranceController = TextEditingController();
  final _startingStakeController = TextEditingController();
  final _roundsController = TextEditingController();

  @override
  void dispose() {
    _bloc.close();
    _profitController.dispose();
    _toleranceController.dispose();
    _roundsController.dispose();
    _processIndicator.dismiss();
    super.dispose();
  }

  @override
  void initState() {
    _bloc.getStake();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            BlocConsumer(
              listener: (context, state) {
                if (state is OnDataLoaded) {
                  decay = state.stake.decay!;
                  clearLosses = state.clearLosses;

                  String? profit = state.stake.profit!.toString();
                  _profitController.text = profit ?? "";
                  _toleranceController.text = state.stake.tolerance!.toString();

                  _startingStakeController.text =
                      state.stake.startingStake!.toString();

                  session = state.stake.id!;

                  if (state.stake.restrictRounds! > 0) {
                    restrictRounds = true;
                    _roundsController.text =
                        state.stake.restrictRounds!.toString();
                  }

                  forfeitLosses = state.stake.forfeit!;
                }

                if (state is OnLoading) {
                  _processIndicator.show(context);
                } else if (state is OnError) {
                  _processIndicator.dismiss().then((value) {
                    showSnack(context,
                        message: state.message, snackType: SnackType.ERROR);
                  });
                } else if (state is OnSuccess) {
                  _processIndicator.dismiss().then((value) {
                    AppRouter.gotoWidget(const Home(), context,
                        clearStack: true);
                  });
                }
              },
              builder: (context, state) => Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 32.h,
                        ),
                        XTextField(
                            label: "Profit", controller: _profitController),
                        Container(
                          height: 16,
                        ),
                        XTextField(
                            label: "Loss Tolerance",
                            controller: _toleranceController),
                        Container(
                          height: 16,
                        ),
                        XTextField(
                            label: "Starting Stake",
                            controller: _startingStakeController),
                        Container(
                          height: 16,
                        ),
                        XSwitch(
                            label: "Decay",
                            activeColor: primaryColor,
                            value: decay,
                            onChanged: (x) {
                              setState(() {
                                decay = x;
                              });
                            }),
                        XSwitch(
                            label: "Forfeit Losses",
                            activeColor: primaryColor,
                            value: forfeitLosses,
                            onChanged: (x) {
                              setState(() {
                                forfeitLosses = x;
                              });
                            }),
                        XSwitch(
                            label: "Clear losses on reset",
                            activeColor: primaryColor,
                            value: clearLosses,
                            onChanged: (x) {
                              setState(() {
                                clearLosses = x;
                                //bloc.setClearLoss(status: x);
                              });
                            }),
                        _recyclePanel(),
                        Container(
                          height: 32.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            _bloc.updateStake(
                                clearLosses: clearLosses,
                                profit: double.parse(
                                    _profitController.text.isNotEmpty
                                        ? _profitController.text
                                        : "0.0"),
                                tolerance: double.parse(
                                    _toleranceController.text.isNotEmpty
                                        ? _toleranceController.text
                                        : "0.0"),
                                decay: decay,
                                statingStake: double.parse(
                                    _startingStakeController.text.isNotEmpty
                                        ? _startingStakeController.text
                                        : "0.0"),
                                forfeit: forfeitLosses,
                                isMultiple: multiStake,
                                restrictRounds:
                                    _roundsController.text.isNotEmpty
                                        ? int.parse(_roundsController.text)
                                        : 0);
                          },
                          child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              bloc: _bloc,
            )
          ],
        ),
      ),
    );
  }

  Widget _recycle_fields() => ExpandablePanel(
      expand: restrictRounds,
      child: Column(
        children: [
          Container(
            height: 16.h,
          ),
          XTextField(label: "Rounds", controller: _roundsController),
        ],
      ));

  Widget _recyclePanel() => Container(
        child: Column(
          children: [
            XSwitch(
                label: "Restrict Rounds",
                activeColor: primaryColor,
                value: restrictRounds,
                onChanged: (x) {
                  setState(() {
                    restrictRounds = x;
                  });
                }),
            _recycle_fields()
          ],
        ),
      );
}
