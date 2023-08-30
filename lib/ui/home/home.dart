import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/ui/core/widget/xstate.dart';
import 'package:stake_calculator/ui/core/xbottom_sheet.dart';
import 'package:stake_calculator/ui/core/xdelete_tag_warning.dart';
import 'package:stake_calculator/ui/core/xdialog.dart';
import 'package:stake_calculator/ui/core/xdrawer.dart';
import 'package:stake_calculator/ui/home/bloc/home_bloc.dart';
import 'package:stake_calculator/ui/home/component/limit_warning.dart';
import 'package:stake_calculator/ui/home/component/setup_account.dart';
import 'package:stake_calculator/ui/home/component/streak_warning.dart';
import 'package:stake_calculator/ui/home/pip/pip.dart';
import 'package:stake_calculator/ui/login/login.dart';
import 'package:stake_calculator/ui/setting/setting.dart';
import 'package:stake_calculator/ui/wallet/wallet.dart';
import 'package:stake_calculator/util/expandable_panel.dart';
import 'package:stake_calculator/util/formatter.dart';
import 'package:stake_calculator/util/game_type.dart';
import 'package:stake_calculator/util/notification_handler/notification_notifier.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../res.dart';
import '../../util/dimen.dart';
import '../../util/notification_handler/notification_handler.dart';
import '../../util/notification_handler/request_notification_permission.dart';
import '../commons.dart';
import '../core/stake_item.dart';
import '../core/tutorial_coach_mark/toturial_coach_mark.dart';
import '../core/xbutton.dart';
import '../core/xcard.dart';
import '../core/xchip.dart';
import '../core/xreset_warning.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../notifications/notifications.dart';
import '../wallet/fund_wallet/component/custom_clipper.dart';
import 'component/home_tour.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends XState<Home> with TickerProviderStateMixin {
  final bloc = HomeBloc();
  bool isMultiple = false;
  GameType selectedGameType = GameType.MULTIPLE;
  GameType defaultGameType = GameType.values[1];
  List<GameType> gameTypes = const [GameType.MULTIPLE, GameType.SINGLE];

  /*
  * Tour guide keys
   */
  final GlobalKey drawerNavKey = GlobalKey();
  final GlobalKey pipKey = GlobalKey();
  final GlobalKey profitKey = GlobalKey();
  final GlobalKey coinsKey = GlobalKey();
  final GlobalKey amountKey = GlobalKey();
  final GlobalKey summaryKey = GlobalKey();
  final GlobalKey tagKey = GlobalKey();
  final GlobalKey resetKey = GlobalKey();
  final GlobalKey calculateKey = GlobalKey();
  final GlobalKey addTagKey = GlobalKey();

  late TutorialCoachMark _pageTour;

  List<int> aspectRatio = [16, 9];
  late Floating floating;
  bool isPipAvailable = false;
  bool showCelebration = false;
  bool isWin = false;

  final ScrollController _controller = ScrollController();

  Map<String, TextEditingController> oddControllers = {};
  Map<String, TextEditingController> tagControllers = {};
  Map<String, bool> tagPairs = {};
  Map<String, FocusNode> tagFocusNodes = {};
  Map<String, FocusNode> oddFocusNodes = {};

  List<Odd> odds = [];
  int notificationCount = 0;

  void _initialPageTour() {
    _pageTour = TutorialCoachMark(
        targets: homeTour(
            drawerNavKey: drawerNavKey,
            pipKey: pipKey,
            profitKey: profitKey,
            coinsKey: coinsKey,
            amountKey: amountKey,
            summaryKey: summaryKey,
            tagKey: tagKey,
            resetKey: resetKey,
            calculateKey: calculateKey,
            addTagKey: addTagKey),
        colorShadow: primaryColor,
        textStyleSkip:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        paddingFocus: 10.h,
        hideSkip: false,
        opacityShadow: 0.9,
        onFinish: () => _finishTour(),
        onSkip: () => _finishTour());
  }

  void _checkNotificationPermission() =>
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          XDialog(context, child: const RequestNotificationPermission()).show();
        }
      });

  void _finishTour() {
    bloc.setHomeToured();
    XDialog(context,
        child: SetupAccount(
          onDefault: () => _checkNotificationPermission(),
          onOk: () => AppRouter.gotoWidget(const Setting(), context)
              .then((_) => _checkNotificationPermission()),
        )).show();
  }

  void _showTour() => Future.delayed(
      const Duration(seconds: 1), () => _pageTour.show(context: context));

  void init() {
    floating = Floating();
    _requestPipAvailable();
    bloc.getStake();
    getFcmToken();

    notificationCount = bloc.getUnReadNotificationsCount();

    notificationNotifier.addListener(() {
      if (mounted) {
        setState(() {
          notificationCount = bloc.getUnReadNotificationsCount();
        });
      }
    });
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
    dismissProcessIndicator();
    notificationNotifier.removeListener(() {});
    super.dispose();
  }

  _scrollBottom() {
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
        drawer: const Drawer(child: XDrawer()),
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          forceMaterialTransparency: true,
          centerTitle: true,
          foregroundColor: backgroundAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                Res.logo_with_name,
                height: 24.h,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        AppRouter.gotoWidget(const Notifications(), context),
                    child: Lottie.asset(
                        notificationCount > 0
                            ? Res.notification_active
                            : Res.notification_bell,
                        height: 28.h,
                        repeat: notificationCount > 0),
                  ),
                  Container(
                    width: 24.w,
                  ),
                  Visibility(
                    visible: isPipAvailable,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          floating.enable(aspectRatio: const Rational(3, 2));
                        });
                      },
                      child: Icon(
                        Icons.picture_in_picture_alt,
                        key: pipKey,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          backgroundColor: backgroundAccent,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener(
              listener: (_, HomeState state) {
                if (state.stake != null && !state.loading) {
                  dismissProcessIndicator().then((_) {
                    if (!bloc.isHomeToured()) {
                      _initialPageTour();
                      _showTour();
                    } else {
                      _checkNotificationPermission();
                    }
                  });
                }

                if (state.loading) {
                  showProcessIndicator();
                } else {
                  dismissProcessIndicator().then((value) {
                    if (isWin && state.stake != null) {
                      _showCelebration();
                    }

                    // data loaded
                    if (state.stake != null) {
                      setState(() {
                        selectedGameType =
                            GameType.values[state.stake?.gameType ?? 0];
                        tagPairs.clear();
                        odds = state.tags ?? [];
                      });
                    }

                    // process login
                    if (state.login) {
                      AppRouter.gotoWidget(const Login(), context,
                          clearStack: true);
                    }

                    // show error
                    if (state.error?.isNotEmpty == true) {
                      dismissProcessIndicator().then((value) => showSnack(
                          context,
                          message: state.error!,
                          snackType: SnackType.ERROR));
                    }

                    // tag added
                    if (state.tagAdded) {
                      _scrollBottom();
                    }

                    //show limit warning
                    if (state.limitWarning) {
                      XDialog(context,
                          child: LimitWarning(
                            onOk: () => bloc.resetStake(won: false),
                            description: Text(
                              "It is highly advised to not chase losses. We will reset your rounds. Kindly take a break and try again later",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16.sp),
                            ),
                            title: 'Loss Limit Reached',
                          )).show();
                    }

                    // show streak Warning
                    if (state.streakWarning) {
                      XDialog(context,
                          child: StreakWarning(
                            onOk: () => bloc.compute(
                                cycle: state.stake!.cycle!,
                                odds: state.tags ?? [],
                                force: true),
                            description: Text(
                              "You are on a losing streak. We will reset your rounds. We highly recommend taking a break and do not chase losses",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16.sp),
                            ),
                            title: 'Rounds Limit Reached',
                          )).show();
                    }
                  });
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
                                  key: resetKey,
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
                                  key: calculateKey,
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
                                  key: addTagKey,
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
                builder: (context, HomeState state) {
                  double profit = 0;
                  if (state.stake != null) {
                    profit = state.stake?.profit ?? 0;
                  }
                  return Row(
                    key: profitKey,
                    children: [
                      Text(
                        "Profit: ",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Text(
                        Formatter.format(profit * 1.0),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
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
                builder: (_, HomeState state) {
                  int coins = 0;
                  if (state.stake != null) {
                    coins = state.stake?.balance ?? 0;
                  }
                  return GestureDetector(
                    onTap: () => AppRouter.gotoWidget(const Wallet(), context),
                    child: Row(
                      key: coinsKey,
                      children: [
                        //const Text("Tolerance: "),
                        Lottie.asset(Res.coins_animation,
                            height: 20.h, width: 20.w, repeat: false),
                        Container(
                          width: 5.w,
                        ),
                        Text(
                          "$coins",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontSize: 16.sp),
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
              key: amountKey,
              children: [
                Text(
                  "Amount to stake",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp),
                ),
                BlocBuilder(
                  builder: (_, HomeState state) {
                    num amount = 0;
                    if (state.stake != null) {
                      amount = state.stake?.previousStake?.value ?? 0;
                    }
                    return Text(
                      Formatter.format(amount * 1.0,
                          decimals: (state.stake?.rounded ?? false) ? 0 : 2),
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 32.sp,
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

  Widget _winStreak() => ClipPath(
        clipper: XClipper(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.all(8.h),
          color: primaryColor.withOpacity(0.2),
          child: BlinkText(
            "You are on a wining streak 🏆. You can reset rounds to prevent losses else you will be reset automatically",
            textAlign: TextAlign.center,
            times: 3,
            style: TextStyle(fontSize: 15.sp, color: const Color(0xFF212121)),
          ),
        ),
      );

  Widget _error() => Container(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber,
              color: Colors.deepOrangeAccent,
              size: 32.h,
            ),
            Container(
              height: 10.w,
            ),
            Text("An unknown error occurred.",
                style: TextStyle(fontSize: 16.sp, color: Colors.black54)),
            Container(
              height: 10.w,
            ),
            GestureDetector(
              onTap: () => bloc.getStake(),
              child: Text(
                "Tap here to try again",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: primaryColor),
              ),
            )
          ],
        ),
      );

  Widget _page() => ListView(
        shrinkWrap: true,
        controller: _controller,
        children: [
          _amount(),
          BlocBuilder(
              bloc: bloc,
              builder: (_, HomeState state) {
                return ExpandablePanel(
                    expand: state.stake != null &&
                        state.stake?.isWiningStreak == true,
                    child: _winStreak());
              }),
          XCard(
              elevation: 0,
              child: BlocBuilder(
                builder: (_, HomeState state) {
                  num? win = 0;
                  double losses = 0;
                  int next = 1;

                  if (state.stake != null) {
                    win = state.stake?.previousStake?.totalWin ?? 0.00;
                    losses = (state.stake?.losses ?? 0);
                    next = state.stake?.cycle ?? 0;
                  }
                  return Container(
                      margin: EdgeInsets.only(left: 16.w, right: 16.w),
                      child: Column(
                        key: summaryKey,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Expected Win:",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                Formatter.format(win.toDouble()),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
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
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                Formatter.format(losses * 1.0),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp),
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Round:",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                "#$next",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp),
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
              builder: (_, HomeState state) => XCard(
                  elevation: 0,
                  key: tagKey,
                  child: Container(
                    margin: EdgeInsets.only(top: 16.h),
                    child: state.tags != null && odds.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: odds.length,
                            itemBuilder: (context, index) {
                              Odd odd = odds[index];

                              tagPairs.putIfAbsent(odd.tag.toString(),
                                  () => odd.isPair ?? false);

                              oddControllers.putIfAbsent(
                                  odd.tag.toString(),
                                  () => TextEditingController(
                                      text: double.parse(
                                                  (odd.odd ?? 0).toString()) <=
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
                                  isLast: odds.length == 1,
                                  isPair: tagPairs[odd.tag.toString()]!,
                                  position: index,
                                  onDelete: (tag, pos) {
                                    XBottomSheet(context,
                                            child: XDeleteTagWarning(
                                                onDelete: (_, pos) {
                                                  bloc.deleteTag(
                                                      position: pos,
                                                      won: false);
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
                                  onUpdate: (tag, pos, pair) {
                                    bloc.updateTag(tag, pos);
                                    setState(() {
                                      tagPairs[odd.tag.toString()] = pair;
                                    });
                                  },
                                  oddFocusNode:
                                      oddFocusNodes[odd.tag.toString()],
                                  tagFocusNode:
                                      tagFocusNodes[odd.tag.toString()],
                                  oddController:
                                      oddControllers[odd.tag.toString()]!,
                                  tagController:
                                      tagControllers[odd.tag.toString()]!,
                                  isOnlyItem: odds.length == 1);
                            })
                        : (state.loading ? Container() : _error()),
                  ))),
        ],
      );

  @override
  void postInitState() {
    init();
  }
}
