import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xswitch.dart';
import 'package:stake_calculator/ui/core/xtext_field.dart';
import 'package:stake_calculator/ui/home/home.dart';
import 'package:stake_calculator/ui/setting/bloc/setting_bloc.dart';
import 'package:stake_calculator/ui/setting/component/setting_warning.dart';
import 'package:stake_calculator/util/expandable_panel.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import 'package:stake_calculator/util/dxt.dart';
import '../../util/process_indicator.dart';
import '../core/tutorial_coach_mark/toturial_coach_mark.dart';
import '../core/xchip.dart';
import '../core/xdialog.dart';
import 'component/setting_tour.dart';

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
  bool approxAmount = true;
  bool decay = false;
  bool clearLosses = false;
  bool keepTags = false;
  bool multiStake = false;

  //tour config
  final GlobalKey profitKey = GlobalKey();
  final GlobalKey lossKey = GlobalKey();
  final GlobalKey earningKey = GlobalKey();
  final GlobalKey startStakeKey = GlobalKey();

  final JustTheController pController = JustTheController();
  final JustTheController tController = JustTheController();
  final JustTheController eController = JustTheController();
  final JustTheController sController = JustTheController();

  late TutorialCoachMark _pageTour;

  final Map<String, String> modeString = {
    "generic":
        "Highest risk exposure with higher profit. Losses a are cumulative of each amount staked at each round. Requires high capital",
    "saver":
        "Lowest risk exposure at a consistent profit. Losses are cleared on every profit providing room for more rounds with low stake amount",
    "advance":
        "Average risk exposure with an average profit. Profit are computed from last point of profit, allowing for low risk exposure",
    "single":
        "Minimal risk exposure with consistent profit. All games are considered as a whole, with cumulative profit equal to set profit"
  };

  void _initialPageTour() {
    _pageTour = TutorialCoachMark(
        targets: settingTour(
            profitKey: profitKey,
            targetKey: earningKey,
            lossesKey: lossKey,
            startingStakeKey: startStakeKey),
        colorShadow: primaryColor,
        textStyleSkip:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        paddingFocus: 10,
        hideSkip: false,
        opacityShadow: 0.9,
        onFinish: () => _bloc.setSettingToured(),
        onSkip: () => _bloc.setSettingToured());
  }

  final ProcessIndicator _processIndicator = ProcessIndicator();
  final _bloc = SettingBloc();

  String? session;

  final _profitController = TextEditingController();
  final _earningController = TextEditingController();
  final _toleranceController = TextEditingController();
  final _startingStakeController = TextEditingController();
  final _roundsController = TextEditingController();

  void _showTour() => Future.delayed(
      const Duration(seconds: 1), () => _pageTour.show(context: context));

  @override
  void dispose() {
    _bloc.close();
    _profitController.dispose();
    _earningController.dispose();
    _toleranceController.dispose();
    _roundsController.dispose();
    _processIndicator.dismiss();
    sController.dispose();
    tController.dispose();
    pController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bloc.getStake();
    if (!_bloc.isSettingToured()) {
      _initialPageTour();
      _showTour();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Settings",
              style: TextStyle(color: Colors.black),
            ),
            GestureDetector(
              onTap: () => _save(),
              child: const Icon(Icons.check),
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            BlocConsumer(
              listener: (context, state) {
                if (state is OnDataLoaded) {
                  decay = state.stake.decay!;
                  clearLosses = state.clearLosses;
                  keepTags = state.keepTag;
                  selectedTab = state.stake.mode;

                  String? profit = state.stake.profit!.toString();
                  _profitController.text = profit ?? "";
                  _toleranceController.text = state.stake.tolerance!.toString();
                  _earningController.text =
                      state.stake.targetEarning.toString();

                  _startingStakeController.text =
                      state.stake.startingStake!.toString();

                  session = state.stake.id!;
                  approxAmount = state.stake.rounded;

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
                //margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 32.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: XTextField(
                                      key: profitKey,
                                      label: "Profit",
                                      controller: _profitController)),
                              Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  child: GestureDetector(
                                    onTap: () => pController.showTooltip(),
                                    child: _infoTip(
                                        message: profitMessage,
                                        controller: pController),
                                  ))
                            ],
                          ),
                          Container(
                            height: 24.h,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: XTextField(
                                      key: earningKey,
                                      label: "Target Earning",
                                      controller: _earningController)),
                              Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  child: GestureDetector(
                                    onTap: () => eController.showTooltip(),
                                    child: _infoTip(
                                        message: targetEarning,
                                        controller: eController),
                                  ))
                            ],
                          ),
                          Container(
                            height: 24.h,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: XTextField(
                                      key: lossKey,
                                      label: "Loss Tolerance",
                                      controller: _toleranceController)),
                              Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  child: GestureDetector(
                                    onTap: () => tController.showTooltip(),
                                    child: _infoTip(
                                        message: toleranceMessage,
                                        controller: tController),
                                  ))
                            ],
                          ),
                          Container(
                            height: 24.h,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: XTextField(
                                      key: startStakeKey,
                                      label: "Starting Stake",
                                      controller: _startingStakeController)),
                              Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  child: GestureDetector(
                                      onTap: () => sController.showTooltip(),
                                      child: _infoTip(
                                          message: stakeMessage,
                                          controller: sController)))
                            ],
                          ),
                          Container(
                            height: 16.h,
                          ),
                        ],
                      ),
                    ),
                    _mode(),
                    _switch(
                        child: XSwitch(
                            label: "Decay",
                            activeColor: primaryColor,
                            value: decay,
                            onChanged: (x) {
                              if (!x) {
                                XDialog(context,
                                    child: SettingWarning(
                                      description: const Text(
                                        "You are about to turn off decay. It is highly recommended to keep it turned on.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                      title: 'Disable Decay?',
                                      onOk: () => setState(() {
                                        decay = x;
                                      }),
                                    )).show();
                              } else {
                                setState(() {
                                  decay = x;
                                });
                              }
                            }),
                        description:
                            "Reduce profit as your consecutive failing rounds increases to reduce risk exposure."),
                    _switch(
                        child: XSwitch(
                            label: "Approximate Amount",
                            activeColor: primaryColor,
                            value: approxAmount,
                            onChanged: (x) {
                              setState(() {
                                approxAmount = x;
                              });
                            }),
                        description:
                            "When set, amount to stake will be rounded up or down to the nearest 5 digit"),
                    _switch(
                        child: XSwitch(
                            label: "Forfeit Losses",
                            activeColor: primaryColor,
                            value: forfeitLosses,
                            onChanged: (x) {
                              setState(() {
                                forfeitLosses = x;
                              });
                            }),
                        description:
                            "Recovery mode is disabled with forfeit losses enabled. Resets on loss tolerance reached"),
                    _switch(
                        child: XSwitch(
                            label: "Clear losses on reset",
                            activeColor: primaryColor,
                            value: clearLosses,
                            onChanged: (x) {
                              setState(() {
                                clearLosses = x;
                              });
                            }),
                        description:
                            "Losses will be cleared on every cycle reset"),
                    _switch(
                        child: XSwitch(
                            label: "Keep tag on delete",
                            activeColor: primaryColor,
                            value: keepTags,
                            onChanged: (x) {
                              setState(() {
                                keepTags = x;
                                //bloc.setClearLoss(status: x);
                              });
                            }),
                        description:
                            "Tags will be persisted on delete after a win. This gives more profit with a higher risk"),
                    _recyclePanel(),
                    Column(
                      children: [
                        Container(
                          height: 32.h,
                        ),
                        GestureDetector(
                          onTap: () => _save(),
                          child: Container(
                            height: 50.h,
                            margin: EdgeInsets.only(
                                left: 24.w, right: 24.w, bottom: 24.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Save Changes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
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

  final _tabsNames = ["generic", "single", "saver", "advance"];
  String selectedTab = "generic";

  Widget _mode() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8.h,
                ),
                const Text(
                  "Working Mode",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  height: 10.h,
                ),
                XChip(
                  choices: _tabsNames,
                  wrapAlignment: WrapAlignment.start,
                  defaultSelected: selectedTab,
                  onSelectedChanged: (String choice) {
                    if (choice != 'saver' && selectedTab == 'saver') {
                      XDialog(context,
                          child: SettingWarning(
                            description: const Text(
                              "You are about to turn off saver mode. It is highly recommended to use xtakee saver mode. If you are unsure of which mode to use, contact our customer service",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                            title: 'Disable Saver Mode?',
                            onOk: () => setState(() {
                              selectedTab = choice;
                            }),
                          )).show();
                    } else {
                      setState(() {
                        selectedTab = choice;
                      });
                    }
                  },
                ),
                Container(
                  height: 5.h,
                ),
                Text(
                  modeString[selectedTab] ?? "",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black45),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            height: 1,
            color: Colors.black12,
          )
        ],
      );

  Widget _infoTip(
          {required String message, required JustTheController controller}) =>
      JustTheTooltip(
          controller: controller,
          content: Padding(
            padding: EdgeInsets.all(8.h),
            child: Text(
              message,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
          ),
          child: const Icon(Icons.info_outline));

  void _save() {
    _bloc.updateStake(
        clearLosses: clearLosses,
        mode: selectedTab,
        approxAmount: approxAmount,
        profit: double.parse(
            _profitController.text.isNotEmpty ? _profitController.text : "0.0"),
        tolerance: double.parse(_toleranceController.text.isNotEmpty
            ? _toleranceController.text
            : "0.0"),
        decay: decay,
        keepTag: keepTags,
        targetEarning: double.parse(_earningController.text),
        startingStake: double.parse(_startingStakeController.text.isNotEmpty
            ? _startingStakeController.text
            : "0.0"),
        forfeit: forfeitLosses,
        isMultiple: multiStake,
        restrictRounds: _roundsController.text.isNotEmpty
            ? (restrictRounds ? int.parse(_roundsController.text) : 0)
            : 0);
  }

  Widget _recycleFields() => ExpandablePanel(
      expand: restrictRounds,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
            child: XTextField(label: "Rounds", controller: _roundsController),
          )
        ],
      ));

  Widget _switch(
          {required Widget child,
          required String description,
          bool divider = true}) =>
      Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                child,
                Text(
                  description,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black45),
                ),
              ],
            ),
          ),
          if (divider)
            Container(
              margin: EdgeInsets.only(top: 10.h),
              height: 1,
              color: Colors.black12,
            )
        ],
      );

  Widget _recyclePanel() => Container(
        child: Column(
          children: [
            _switch(
                divider: false,
                child: XSwitch(
                    label: "Restrict Rounds",
                    activeColor: primaryColor,
                    value: restrictRounds,
                    onChanged: (x) {
                      setState(() {
                        restrictRounds = x;
                      });
                    }),
                description:
                    "Set maximum rounds after which calculator resets"),
            _recycleFields()
          ],
        ),
      );
}
