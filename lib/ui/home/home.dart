import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/ui/core/xbottom_sheet.dart';
import 'package:stake_calculator/ui/core/xdelete_tag_warning.dart';
import 'package:stake_calculator/ui/core/xdrawer.dart';
import 'package:stake_calculator/ui/home/bloc/home_bloc.dart';
import 'package:stake_calculator/ui/home/pip/pip.dart';
import 'package:stake_calculator/ui/wallet/wallet.dart';
import 'package:stake_calculator/util/expandable_panel.dart';
import 'package:stake_calculator/util/formatter.dart';
import 'package:stake_calculator/util/game_type.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../res.dart';
import '../../util/dimen.dart';
import '../../util/process_indicator.dart';
import '../commons.dart';
import '../core/stake_item.dart';
import '../core/xbutton.dart';
import '../core/xcard.dart';
import '../core/xchip.dart';
import '../core/xreset_warning.dart';
import '../not_found/not_found.dart';
import 'package:stake_calculator/util/dxt.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<Home> with TickerProviderStateMixin {
  final ProcessIndicator _processIndicator = ProcessIndicator();
  final bloc = HomeBloc();
  bool isMultiple = false;
  final listKey = const Key("key");
  GameType selectedGameType = GameType.MULTIPLE;
  GameType defaultGameType = GameType.values[1];
  List<GameType> gameTypes = const [GameType.MULTIPLE, GameType.SINGLE];

  List<int> aspectRatio = [16, 9];
  late Floating floating;
  bool isPipAvailable = false;
  bool showCelebration = false;
  bool isWin = false;

  final ScrollController _controller = ScrollController();

  Map<String, TextEditingController> oddControllers = {};
  Map<String, TextEditingController> tagControllers = {};
  Map<String, FocusNode> tagFocusNodes = {};
  Map<String, FocusNode> oddFocusNodes = {};

  List<Odd> odds = [];

  @override
  void initState() {
    floating = Floating();
    _requestPipAvailable();
    bloc.getStake();
    super.initState();
  }

  void _requestPipAvailable() async {
    floating.isPipAvailable.then((value) {
      setState(() {
        isPipAvailable = value;
      });
    });
  }

  void _disposeAllFocus() {
    tagFocusNodes.forEach((key, value) {
      value.dispose();
    });

    oddFocusNodes.forEach((key, value) {
      value.dispose();
    });
  }

  void _clearAllFocus() {
    tagFocusNodes.forEach((key, value) {
      if (value.hasFocus) {
        value.unfocus();
      }
    });

    oddFocusNodes.forEach((key, value) {
      if (value.hasFocus) {
        value.unfocus();
      }
    });
  }

  @override
  void dispose() {
    bloc.close();
    _disposeAllFocus();
    super.dispose();
  }

  _scrollBottom() {
    // _controller
    //     .animateTo(
    //   MediaQuery.of(context).size.height,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 300),
    // )
    //     .then((value) {
    //   tagFocusNodes[odds.last.tag.toString()]?.requestFocus();
    // });
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      tagFocusNodes[odds.last.tag.toString()]?.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    setScale(MediaQuery.of(context).size);
    return PiPSwitcher(
        childWhenEnabled: const Pip(), childWhenDisabled: _screen());
  }

  void _showCelebration() {
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      _clearAllFocus();
      setState(() {
        showCelebration = true;
        isWin = false;
      });
    });

    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {
        showCelebration = false;
      });
    });
  }

  Widget _screen() => Scaffold(
        backgroundColor: backgroundAccent,
        drawer: xDrawer(context),
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          forceMaterialTransparency: true,
          foregroundColor: backgroundAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: isPipAvailable,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      floating.enable(aspectRatio: const Rational(3, 2));
                    });
                  },
                  child: const Icon(
                    Icons.picture_in_picture_alt,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          backgroundColor: backgroundAccent,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener(
              listener: (BuildContext context, state) {
                if (state is OnLoading) {
                  _processIndicator.show(context);
                } else if (state is OnDataLoaded) {
                  _processIndicator.dismiss().then((value) {
                    if (isWin) {
                      _showCelebration();
                    }
                  });
                  selectedGameType = GameType.values[state.stake.gameType ?? 0];
                  odds = state.odds;
                } else if (state is OnCreateStake) {
                  _processIndicator.dismiss().then((value) => {
                        AppRouter.gotoWidget(const NotFound(), context,
                            clearStack: true)
                      });
                } else if (state is OnError) {
                  _processIndicator.dismiss().then((value) => showSnack(context,
                      message: state.message, snackType: SnackType.ERROR));
                } else if (state is OnTagAdded) {
                  _scrollBottom();
                } else {
                  _processIndicator.dismiss();
                }
              },
              bloc: bloc,
            )
          ],
          child: SafeArea(
            child: SizedBox(
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      color: backgroundAccent,
                      height: 50.h,
                    ),
                  ),
                  Container(
                    color: primaryBackground,
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 16.w, right: 16.w),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryBackground,
                          ),
                          child: _page(),
                        )),
                        Container(
                          width: double.infinity,
                          height: 50.h,
                          color: primaryBackground,
                          margin: EdgeInsets.only(
                              top: 16.h, left: 16.w, right: 16.w, bottom: 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  XBottomSheet(context,
                                      child: XResetWarning(onReset: () {
                                        bloc.resetStake();
                                      }, onWon: () {
                                        bloc.resetStake(won: true);
                                        isWin = true;
                                      })).show();
                                },
                                child: Container(
                                  height: 50.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(
                                    Icons.restart_alt_outlined,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: 16.w,
                              ),
                              Expanded(
                                  child: XButton(
                                label: "Calculate",
                                onClick: () =>
                                    bloc.compute(cycle: 1, odds: odds),
                              )),
                              Container(
                                width: 16.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (odds.length == 1) {
                                    selectedGameType = defaultGameType;
                                  }
                                  bloc.saveTag(Odd(name: "", odd: 0));
                                },
                                child: Container(
                                  height: 50.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(
                                    Icons.add,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showCelebration)
                    Positioned.fill(child: Lottie.asset(Res.hurry_animation))
                ],
              ),
            ),
          ),
        ),
      );

  Widget _amount() => XCard(
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              BlocBuilder(
                builder: (context, state) {
                  double profit = 0;
                  if (state is OnDataLoaded) {
                    profit = state.stake.profit ?? 0;
                  }
                  return Row(
                    children: [
                      const Text("Profit: "),
                      Text(
                        Formatter.format(profit * 1.0),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  );
                },
                bloc: bloc,
              ),
              Container(
                width: 16.w,
              ),
              BlocBuilder(
                builder: (context, state) {
                  int coins = 0;
                  if (state is OnDataLoaded) {
                    coins =
                        (state.stake.coins ?? 0) - (state.stake.stakes ?? 0);
                  }
                  return GestureDetector(
                    onTap: () => AppRouter.gotoWidget(const Wallet(), context),
                    child: Row(
                      children: [
                        //const Text("Tolerance: "),
                        Lottie.asset(Res.coins_animation,
                            height: 20.h, width: 20.w),
                        Container(
                          width: 5.w,
                        ),
                        Text(
                          "$coins",
                          textScaleFactor: scale,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontSize: 16),
                        )
                      ],
                    ),
                  );
                },
                bloc: bloc,
              ),
            ],
          ),
          Container(
            height: 2,
            margin: EdgeInsets.only(top: 5.h),
            color: const Color(0xFFEFEFEF),
            width: double.infinity,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            child: Column(
              children: [
                Text(
                  "Amount to stake",
                  textScaleFactor: scale,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                BlocBuilder(
                  builder: (context, state) {
                    num? amount = 0;
                    if (state is OnDataLoaded) {
                      amount = state.stake.previousStake?.value;
                    }
                    return Text(
                      Formatter.format(amount! * 1.0),
                      textScaleFactor: scale,
                      style: const TextStyle(
                          color: primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w800),
                    );
                  },
                  bloc: bloc,
                )
              ],
            ),
          )
        ],
      ));

  Widget _page() => ListView(
        shrinkWrap: true,
        controller: _controller,
        children: [
          _amount(),
          XCard(
              elevation: 0,
              child: BlocBuilder(
                builder: (context, state) {
                  num? win = 0;
                  double losses = 0;
                  int next = 1;

                  if (state is OnDataLoaded) {
                    win = state.stake.previousStake?.totalWin ?? 0.00;
                    losses = (state.stake.losses ?? 0);
                    next = state.stake.cycle ?? 0;
                  }
                  return Container(
                      margin: EdgeInsets.only(left: 16.w, right: 16.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Expected Win:",
                                textScaleFactor: scale,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                Formatter.format(win.toDouble()),
                                textScaleFactor: scale,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.green.withOpacity(0.9)),
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Losses:",
                                textScaleFactor: scale,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                Formatter.format(losses * 1.0),
                                textScaleFactor: scale,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Round:",
                                textScaleFactor: scale,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                "#$next",
                                textScaleFactor: scale,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              )
                            ],
                          ),
                        ],
                      ));
                },
                bloc: bloc,
              )),
          BlocBuilder(
              bloc: bloc,
              builder: (_, state) {
                return ExpandablePanel(
                    expand: odds.length > 1,
                    child: XCard(
                      elevation: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          XChip(
                            choices: gameTypes.map((e) => e.name).toList(),
                            defaultSelected: selectedGameType.name,
                            onSelectedChanged: (choice) {
                              bloc.setGameType(
                                  type: GameType.values
                                      .firstWhere((e) => e.name == choice));
                            },
                          )
                        ],
                      ),
                    ));
              }),
          BlocBuilder(
              bloc: bloc,
              builder: (context, state) => XCard(
                  elevation: 0,
                  key: listKey,
                  child: Container(
                    margin: EdgeInsets.only(top: 16.h),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: odds.length,
                        itemBuilder: (context, index) {
                          Odd odd = odds[index];

                          oddControllers.putIfAbsent(
                              odd.tag.toString(),
                              () => TextEditingController(
                                  text:
                                      double.parse((odd.odd ?? 0).toString()) <=
                                              0
                                          ? ""
                                          : odd.odd?.toString()));

                          tagControllers.putIfAbsent(
                              odd.tag.toString(),
                              () => TextEditingController(
                                  text: odd.name?.toString()));

                          oddFocusNodes.putIfAbsent(
                              odd.tag.toString(), () => FocusNode());

                          tagFocusNodes.putIfAbsent(
                              odd.tag.toString(), () => FocusNode());

                          return StakeItem(
                              isLast: odds.length == (index + 1),
                              position: index,
                              onDelete: (tag, pos) {
                                XBottomSheet(context,
                                        child: XDeleteTagWarning(
                                            onDelete: (_, pos) {
                                              bloc.deleteTag(
                                                  position: pos, won: false);
                                            },
                                            onWon: (_, pos) {
                                              bloc.deleteTag(
                                                  position: pos, won: true);
                                              isWin = true;
                                            },
                                            position: pos,
                                            tag: tag))
                                    .show();
                              },
                              onUpdate: (tag, pos) {
                                bloc.updateTag(tag, pos);
                              },
                              oddFocusNode: oddFocusNodes[odd.tag.toString()],
                              tagFocusNode: tagFocusNodes[odd.tag.toString()],
                              oddController:
                                  oddControllers[odd.tag.toString()]!,
                              tagController:
                                  tagControllers[odd.tag.toString()]!,
                              isOnlyItem: odds.length == 1);
                        }),
                  ))),
        ],
      );
}
