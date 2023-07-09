import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/domain/model/previous_stake.dart';
import 'package:stake_calculator/ui/home/bloc/home_bloc.dart';
import 'package:stake_calculator/ui/setting/setting.dart';
import 'package:stake_calculator/util/formatter.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../res.dart';
import '../../util/process_indicator.dart';
import '../commons.dart';
import '../core/stake_item.dart';
import '../core/xcard.dart';
import '../not_found/not_found.dart';
import 'package:stake_calculator/util/dxt.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<Home> {
  late final ProcessIndicator _processIndicator = ProcessIndicator();
  final bloc = HomeBloc();
  bool isMultiple = false;
  final listKey = const Key("key");

  final ScrollController _controller = ScrollController();

  Map<String, TextEditingController> oddControllers = {};
  Map<String, TextEditingController> tagControllers = {};

  List<Odd> odds = [];

  @override
  void initState() {
    bloc.getStake();
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    oddControllers.clear();
    tagControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Transform.scale(
                  scaleY: 0.8,
                  scaleX: 0.9,
                  child: SvgPicture.asset(
                    Res.logo_with_name,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () async {
                await AppRouter.gotoWidget(const Setting(), context);
              },
              child: const Icon(Icons.settings, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: primaryColor,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener(
            listener: (BuildContext context, state) {
              if (state is OnLoading) {
                _processIndicator.show(context);
              } else if (state is OnDataLoaded) {
                _processIndicator.dismiss();

                odds = state.odds;
                _controller.jumpTo(_controller.position.maxScrollExtent);
              } else if (state is OnCreateStake) {
                _processIndicator.dismiss().then((value) => {
                      AppRouter.gotoWidget(const NotFound(), context,
                          clearStack: true)
                    });
              } else if (state is OnError) {
                _processIndicator.dismiss().then((value) => showSnack(context,
                    message: state.message, snackType: SnackType.ERROR));
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
                  child: Container(
                    color: primaryColor,
                    height: 50.h,
                  ),
                ),
                Column(
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
                      child: Column(
                        children: [_amount(), Expanded(child: _page())],
                      ),
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
                              bloc.resetStake();
                            },
                            child: Container(
                              height: 50.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                              child: GestureDetector(
                            onTap: () {
                              bloc.compute(cycle: 1, odds: odds);
                            },
                            child: Container(
                              height: 50.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                "Calculate",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                          Container(
                            width: 16.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              bloc.saveTag(
                                  Odd(name: "#${odds.length + 1}", odd: 1.10));
                            },
                            child: Container(
                              height: 50.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _amount() => XCard(
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                  double tolerance = 0;
                  if (state is OnDataLoaded) {
                    tolerance = state.stake.tolerance ?? 0;
                  }
                  return Row(
                    children: [
                      const Text("Tolerance: "),
                      Text(
                        Formatter.format(tolerance * 1.0),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  );
                },
                bloc: bloc,
              ),
            ],
          ),
          Container(
            height: 5,
            margin: EdgeInsets.only(top: 10.h),
            color: const Color(0xFFEFEFEF),
            width: double.infinity,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            child: Column(
              children: [
                const Text(
                  "Amount to stake",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w900,
                      fontSize: 18),
                ),
                BlocBuilder(
                  builder: (context, state) {
                    num? amount = 0;
                    if (state is OnDataLoaded) {
                      amount = state.stake.previousStake?.value;
                    }
                    return Text(
                      Formatter.format(amount! * 1.0),
                      style: const TextStyle(
                          color: primaryColor,
                          fontSize: 38,
                          fontWeight: FontWeight.w900),
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
          XCard(
              elevation: 0,
              child: BlocBuilder(
                builder: (context, state) {
                  num? win = 0;
                  double losses = 0;
                  int next = 1;

                  if (state is OnDataLoaded) {
                    win = state.stake.previousStake?.expectedWin ?? 0.00;
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
                              const Text(
                                "Expected Win:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                Formatter.format(win.toDouble()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          Container(
                            height: 5,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Losses:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                Formatter.format(losses * 1.0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          Container(
                            height: 5.h,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Round:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                "#$next",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                        ],
                      ));
                },
                bloc: bloc,
              )),
          Container(
            height: 5.h,
          ),
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
                                  text: odd.odd?.toString()));

                          tagControllers.putIfAbsent(
                              odd.tag.toString(),
                              () => TextEditingController(
                                  text: odd.name?.toString()));

                          return StakeItem(
                              isLast: odds.length == (index + 1),
                              position: index,
                              onDelete: (tag, pos) {
                                bloc.deleteTag(pos);
                              },
                              onUpdate: (tag, pos) {
                                bloc.updateTag(tag, pos);
                              },
                              previousStake: PreviousStake(),
                              oddController: oddControllers[odd.tag.toString()]!,
                              tagController: tagControllers[odd.tag.toString()]!,
                              isOnlyItem: odds.length == 1);
                        }),
                  ))),
        ],
      );

  List<StakeItem> _items() {
    int index = 0;
    List<StakeItem> items = [];
    for (var odd in odds) {
      oddControllers.putIfAbsent(odd.tag.toString(),
          () => TextEditingController(text: odd.odd?.toString()));

      tagControllers.putIfAbsent(odd.tag.toString(),
          () => TextEditingController(text: odd.tag?.toString()));

      items.add(StakeItem(
          isLast: odds.length == (index + 1),
          position: index,
          onDelete: (tag, pos) {
            bloc.deleteTag(pos);
          },
          onUpdate: (tag, pos) {
            bloc.updateTag(tag, pos);
          },
          previousStake: PreviousStake(),
          oddController: oddControllers[odd.tag.toString()]!,
          tagController: tagControllers[odd.tag.toString()]!,
          isOnlyItem: odds.length == 1));

      index++;
    }

    return items;
  }
}
