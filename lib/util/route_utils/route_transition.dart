/*
BSD 2-Clause License

Copyright (c) 2019, Adib Mohsin
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import 'package:flutter/material.dart';

/// AnimationType defines what route transtition should take place
enum AnimationType {
  slide_right,
  slide_left,
  slide_up,
  slide_down,
  fade,
  scale,
}

/// The main class that defines a custom Route transition / animation
/// [WidgetBuilder builder] is required
/// [Curves curves] is optional , by default it is set to [Curves.easeInOut]
class RouteTransition extends MaterialPageRoute {
  AnimationType animationType;
  Cubic curves;

  RouteTransition(
      {required WidgetBuilder builder,
      RouteSettings? settings,
      this.animationType = AnimationType.slide_right,
      this.curves = Curves.easeInOut,
      bool maintainState = true,
      bool fullscreenDialog = false})
      : super(
            builder: builder,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animation customAnimation;
    if (animationType == AnimationType.slide_right) {
      customAnimation = Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
          .animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return SlideTransition(
        position: customAnimation as Animation<Offset>,
        child: child,
      );
    } else if (animationType == AnimationType.slide_left) {
      customAnimation = Tween(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
          .animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return SlideTransition(
        position: customAnimation as Animation<Offset>,
        child: child,
      );
    } else if (animationType == AnimationType.slide_up) {
      customAnimation = Tween(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
          .animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return SlideTransition(
        position: customAnimation as Animation<Offset>,
        child: child,
      );
    } else if (animationType == AnimationType.slide_down) {
      customAnimation = Tween(begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0))
          .animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return SlideTransition(
        position: customAnimation as Animation<Offset>,
        child: child,
      );
    } else if (animationType == AnimationType.fade) {
      customAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return FadeTransition(
        opacity: customAnimation as Animation<double>,
        child: child,
      );
    } else if (animationType == AnimationType.scale) {
      customAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return ScaleTransition(
        scale: customAnimation as Animation<double>,
        child: child,
      );
    } else {
      throw Exception("Animation type is invalid or null");
    }
  }
}
