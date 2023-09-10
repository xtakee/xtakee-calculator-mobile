import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../core/tutorial_coach_mark/target/target_content.dart';
import '../../core/tutorial_coach_mark/target/target_focus.dart';
import '../../core/tutorial_coach_mark/util.dart';

const profitMessage =
    'Set your target profit on each round. Your total profit is a multiple of the total rounds';
const toleranceMessage =
    'Set your stop loss after which calculator resets current rounds';
const stakeMessage =
    'Set your minimum amount playable on your betting book-marker/website of choice';

const targetEarning =
    'Set your target earning after which xtakee halts your betting activity to a future time. This is to prevent being carried away.';

List<TargetFocus> settingTour(
    {required GlobalKey profitKey,
    required GlobalKey lossesKey,
      required GlobalKey targetKey,
    required GlobalKey startingStakeKey}) {
  List<TargetFocus> targets = [];

  targets.add(_profitTargetTour(key: profitKey));
  targets.add(_earningTargetTour(key: targetKey));

  targets.add(_lossesTargetTour(key: lossesKey));
  targets.add(_startStakeTargetTour(key: startingStakeKey));

  return targets;
}
_earningTargetTour({required GlobalKey key}) => TargetFocus(
  keyTarget: key,
  alignSkip: Alignment.bottomLeft,
  alignNext: Alignment.bottomRight,
  shape: ShapeLightFocus.RRect,
  radius: 10,
  contents: [
    TargetContent(
      align: ContentAlign.bottom,
      builder: (context, controller) => Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Target Earning',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            Text(
              targetEarning,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
);

_profitTargetTour({required GlobalKey key}) => TargetFocus(
      keyTarget: key,
      alignSkip: Alignment.bottomLeft,
      alignNext: Alignment.bottomRight,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) => Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Profit Per Round',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
                Text(
                  profitMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

_lossesTargetTour({required GlobalKey key}) => TargetFocus(
      keyTarget: key,
      alignSkip: Alignment.bottomLeft,
      alignNext: Alignment.bottomRight,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) => Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Loss Tolerance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
                Text(
                  toleranceMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

_startStakeTargetTour({required GlobalKey key}) => TargetFocus(
      keyTarget: key,
      alignSkip: Alignment.bottomLeft,
      alignNext: Alignment.bottomRight,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) => Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Starting Stake',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
                Text(
                  stakeMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
