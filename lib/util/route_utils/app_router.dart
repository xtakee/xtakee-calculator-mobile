import 'package:flutter/material.dart';
import 'package:stake_calculator/util/route_utils/route_transition.dart';

class AppRouter {
  static Future gotoWidget(
    Widget screen,
    BuildContext context, {
    bool clearStack = false,
    bool fullScreenDialog = false,
    AnimationType animationType = AnimationType.slide_right,
  }) {
    return !clearStack
        ? Navigator.of(context).push(RouteTransition(
            animationType: animationType,
            builder: (context) => screen,
            fullscreenDialog: fullScreenDialog))
        : Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => screen,
                fullscreenDialog: fullScreenDialog),
            (_) => false);
  }

  static gotoNamed(String route, BuildContext context,
      {bool clearStack = false, dynamic args = Object}) {
    return !clearStack
        ? Navigator.of(context).pushNamed(route, arguments: args)
        : Navigator.of(context)
            .pushNamedAndRemoveUntil(route, (_) => false, arguments: args);
  }

  static void goBack(BuildContext context,
      {bool rootNavigator = false, result}) {
    Navigator.of(context, rootNavigator: rootNavigator).pop(result);
  }
}
