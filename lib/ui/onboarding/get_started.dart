import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/widget/xstate.dart';
import 'package:stake_calculator/ui/core/xdialog.dart';
import 'package:stake_calculator/ui/home/home.dart';
import 'package:stake_calculator/ui/onboarding/get_started_pop.dart';
import 'package:stake_calculator/util/config.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends XState<GetStarted> {
  late final WebViewController _controller;
  double _percent = 0;

  @override
  void postInitState() {
    XDialog(context, child: const GetStartedPop()).show();
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(primaryBackground)
      ..setNavigationDelegate(
        NavigationDelegate(
            onProgress: (int progress) {
              setState(() {
                _percent = (progress / 100);
              });
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              _percent = 1;
              _controller.runJavaScript(
                  "document.getElementsByTagName('nav')[0].style.display='none'");
              _controller.runJavaScript(
                  "document.getElementsByTagName('footer')[0].style.display='none'");

              _controller.runJavaScript(
                  "document.getElementById('content-wrapper').style.display='none'");
            }),
      )
      ..loadRequest(Uri.parse(Config.shared.webBaseUrl));
  }

  _goBack() {
    AppRouter.gotoWidget(const Home(), context, clearStack: true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: primaryBackground,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => _goBack(),
              child: Text(
                "Done",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: WillPopScope(
          child: SafeArea(
              child: Column(
            children: [
              if (_percent < 1)
                LinearPercentIndicator(
                    percent: _percent,
                    lineHeight: 2.h,
                    progressColor: primaryColor),
              Expanded(child: WebViewWidget(controller: _controller))
            ],
          )),
          onWillPop: () async => _goBack()));
}
