import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/login/login.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../core/page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<OnBoarding> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    Res.intro_background,
                    height: 96.h,
                  )),
              Positioned.fill(child: SvgPicture.asset(Res.intro_background)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(top: 64.h),
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (x) {
                        setState(() {
                          _currentPageNotifier.value = x;
                        });
                      },
                      children: [
                        _page(
                            title: "Bet Smarter, Beat\nthe Bookmarkers",
                            description:
                                "Maximize your wins and elevate your betting game to new heights!",
                            image: Res.intro_st1),
                        _page(
                            title: "Unleash the Power\nof Calculated Risks",
                            description:
                                "Maximize your wins and elevate your betting game to new heights!",
                            image: Res.intro_st2),
                        _page(
                            title: "Elevate Your\nBetting Experience",
                            description:
                                "Maximize your wins and elevate your betting game to new heights!",
                            image: Res.intro_st3)
                      ],
                    ),
                  )),
                  SafeArea(
                      child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _stepIndicator(),
                        (_currentPageNotifier.value < 2) ? _next() : _start()
                      ],
                    ),
                  ))
                ],
              ),
              Positioned(
                  top: 48.h,
                  left: 16.w,
                  child: SvgPicture.asset(
                    Res.logo_with_name,
                    height: 24.h,
                  ))
            ],
          ),
        ),
      );

  _next() => GestureDetector(
        onTap: () {
          _pageController.animateToPage(_pageController.page!.toInt() + 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            "Next",
            style: TextStyle(
                color: primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
      );

  _start() => GestureDetector(
        onTap: () =>
            AppRouter.gotoWidget(const Login(), context, clearStack: true),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(10.h)),
          child: Text(
            "Get Started",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
      );

  _page(
          {required String title,
          required String description,
          required String image}) =>
      Stack(
        children: [
          Positioned(
              bottom: 32.h,
              top: 0,
              right: 0,
              left: 0,
              child: SvgPicture.asset(image)),
          Positioned(
              bottom: 0,
              left: 0,
              right: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        left: 16.w, right: 16.w, bottom: 10.h, top: 32.h),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.sp,
                          height: 1.1.h),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      description,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.sp),
                    ),
                  )
                ],
              ))
        ],
      );

  _stepIndicator() => PageIndicator(
        pageIndexNotifier: _currentPageNotifier,
        length: 3,
        normalBuilder: (animationController, index) => Container(
          width: 10.w,
          height: 10.w,
          decoration: const BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
        ),
        indicatorPadding: const EdgeInsets.all(3),
        highlightedBuilder: (animationController, index) => ScaleTransition(
          scale: CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
          ),
          child: Container(
            width: 10.w,
            height: 10.w,
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
}
