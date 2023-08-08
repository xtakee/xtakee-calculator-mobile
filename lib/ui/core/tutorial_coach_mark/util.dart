
// ignore: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/core/tutorial_coach_mark/target/target_focus.dart';
import 'package:stake_calculator/ui/core/tutorial_coach_mark/target/target_position.dart';

enum ShapeLightFocus { Circle, RRect }

TargetPosition? getTargetCurrent(
    TargetFocus target, {
      bool rootOverlay = false,
    }) {
  if (target.keyTarget != null) {
    var key = target.keyTarget!;

    try {
      final RenderBox renderBoxRed =
      key.currentContext!.findRenderObject() as RenderBox;
      final size = renderBoxRed.size;

      BuildContext? context;
      if (rootOverlay) {
        context = key.currentContext!
            .findRootAncestorStateOfType<OverlayState>()
            ?.context;
      } else {
        context = key.currentContext!
            .findAncestorStateOfType<NavigatorState>()
            ?.context;
      }
      Offset offset;
      if (context != null) {
        offset = renderBoxRed.localToGlobal(
          Offset.zero,
          ancestor: context.findRenderObject(),
        );
      } else {
        offset = renderBoxRed.localToGlobal(Offset.zero);
      }

      return TargetPosition(size, offset);
    } catch (e) {
      throw NotFoundTargetException();
    }
  } else {
    return target.targetPosition;
  }
}

abstract class TutorialCoachMarkController {
  void next();
  void previous();
  void skip();
}

extension StateExt on State {
  void safeSetState(VoidCallback call) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(call);
    }
  }
}

class NotFoundTargetException extends FormatException {
  NotFoundTargetException()
      : super('It was not possible to obtain target position.');
}

void postFrame(VoidCallback callback) {
  Future.delayed(Duration.zero, callback);
}

extension NullableExt<T> on T? {
  void let(Function(T it) callback) {
    if (this != null) {
      callback(this as T);
    }
  }
}
