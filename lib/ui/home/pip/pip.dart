import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stake_calculator/domain/model/odd.dart';
import 'package:stake_calculator/ui/home/pip/bloc/pip_bloc.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../../res.dart';
import '../../../util/formatter.dart';
import '../../commons.dart';

class Pip extends StatefulWidget {
  const Pip({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Pip> {
  final bloc = PipBloc();

  @override
  void initState() {
    bloc.getStake();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white.withOpacity(0.1),
      body: Container(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryColor, width: 1)),
        child: Stack(
          children: [
            Positioned.fill(
                child: Opacity(
              opacity: 0.15,
              child: SvgPicture.asset(Res.logo),
            )),
            BlocBuilder(
              builder: (context, state) {
                num? amount = 0;
                List<Odd> tags = [];
                num? win = 0;
                double losses = 0;
                int next = 1;

                if (state is OnDataLoaded) {
                  amount = state.stake.previousStake?.value;
                  win = state.stake.previousStake?.expectedWin ?? 0.00;
                  losses = (state.stake.losses ?? 0);
                  next = state.stake.cycle ?? 0;
                  tags = state.tags;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 28,
                      child: AutoSizeText(
                        Formatter.format(amount! * 1.0),
                        maxLines: 1,
                        softWrap: true,
                        style: const TextStyle(
                            color: primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 16.w, right: 16.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AutoSizeText(
                                  "Win:",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                AutoSizeText(
                                  Formatter.format(win.toDouble()),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Container(
                              height: 3,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AutoSizeText(
                                  "Losses:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                AutoSizeText(
                                  Formatter.format(losses * 1.0),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Container(
                              height: 3,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AutoSizeText(
                                  "Round:",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                AutoSizeText(
                                  "#$next",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AutoSizeText(
                                  "Tags: ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                Flexible(
                                    child: AutoSizeText(
                                  tags.string(),
                                  textAlign: TextAlign.end,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))
                              ],
                            ),
                          ],
                        ))
                  ],
                );
              },
              bloc: bloc,
            )
          ],
        ),
      ));
}
