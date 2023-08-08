import 'package:flutter/material.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../core/tutorial_coach_mark/target/target_content.dart';
import '../../core/tutorial_coach_mark/target/target_focus.dart';
import '../../core/tutorial_coach_mark/util.dart';

List<TargetFocus> homeTour(
    {required GlobalKey drawerNavKey,
    required GlobalKey pipKey,
    required GlobalKey profitKey,
    required GlobalKey coinsKey,
    required GlobalKey amountKey,
    required GlobalKey summaryKey,
    required GlobalKey tagKey,
    required GlobalKey resetKey,
    required GlobalKey calculateKey,
    required GlobalKey addTagKey}) {
  List<TargetFocus> targets = [];

  targets.add(_pipTargetTour(key: pipKey));
  targets.add(_profitTargetTour(key: profitKey));
  targets.add(_coinsTargetTour(key: coinsKey));
  targets.add(_amountTargetTour(key: amountKey));
  targets.add(_summaryTargetTour(key: summaryKey));
  targets.add(_tagsTargetTour(key: tagKey));
  targets.add(_resetTargetTour(key: resetKey));
  targets.add(_calculateTargetTour(key: calculateKey));
  targets.add(_addTargetTour(key: addTagKey));

  return targets;
}

_pipTargetTour({required GlobalKey key}) => TargetFocus(
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
                  'Float Calculator',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
                Text(
                  'This will minimise and float xtakee calculator',
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
                  'Target profit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
                Text(
                  'Your set profit on every stake',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

_coinsTargetTour({required GlobalKey key}) => TargetFocus(
  keyTarget: key,
  alignSkip: Alignment.bottomLeft,
  shape: ShapeLightFocus.RRect,
  radius: 10,
  contents: [
    TargetContent(
      align: ContentAlign.bottom,
      builder: (context, controller) => Container(
        alignment: Alignment.center,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Available Coins',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            Text(
              'Your available coin balance will show here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
);

_amountTargetTour({required GlobalKey key}) => TargetFocus(
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
              'Amount to Stake',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            Text(
              'This is the amount to stake on each game in current round. This can either be single or multiple',
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

_summaryTargetTour({required GlobalKey key}) => TargetFocus(
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
              'Stake Summary',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            Text(
              'Your expected win on current round, total losses incurred and the current round will be shown here',
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

_tagsTargetTour({required GlobalKey key}) => TargetFocus(
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
              'Game/Tags',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            Text(
              'Enter team name(s) as tag(s) and the odd(s) here. You can add multiple games/teams with the respective odd at the same time',
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

_resetTargetTour({required GlobalKey key}) => TargetFocus(
  keyTarget: key,
  alignSkip: Alignment.bottomLeft,
  alignNext: Alignment.bottomRight,
  shape: ShapeLightFocus.RRect,
  radius: 10,
  contents: [
    TargetContent(
      align: ContentAlign.top,
      builder: (context, controller) => Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Reset Rounds',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            Text(
              'This will reset current round. You can reset rounds if all teams/games wins or a forfeiture',
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

_calculateTargetTour({required GlobalKey key}) => TargetFocus(
  keyTarget: key,
  alignSkip: Alignment.bottomLeft,
  alignNext: Alignment.bottomRight,
  shape: ShapeLightFocus.RRect,
  radius: 10,
  contents: [
    TargetContent(
      align: ContentAlign.top,
      builder: (context, controller) => Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Calculate Amount',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            Text(
              'This will calculate the expected stake amount for current round. You must calculate amount for each round',
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

_addTargetTour({required GlobalKey key}) => TargetFocus(
  keyTarget: key,
  alignSkip: Alignment.bottomLeft,
  alignNext: Alignment.bottomRight,
  shape: ShapeLightFocus.RRect,
  radius: 10,
  contents: [
    TargetContent(
      align: ContentAlign.top,
      builder: (context, controller) => Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add Game/Team',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
            Text(
              'You can always add multiple teams/games at the same time with the corresponding odd(s)',
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