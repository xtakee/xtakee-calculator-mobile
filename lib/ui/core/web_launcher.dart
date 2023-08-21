import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/util/config.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebLauncher extends StatefulWidget {
  final String path;

  const WebLauncher({super.key, required this.path});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WebLauncher> {
  late final WebViewController _controller;
  double _percent = 0;

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
            }),
      )
      ..loadRequest(Uri.parse('${Config.shared.webBaseUrl}${widget.path}'));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: primaryBackground,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Column(
        children: [
          if (_percent < 1)
            LinearPercentIndicator(
                percent: _percent,
                lineHeight: 2.h,
                progressColor: primaryColor),
          Expanded(child: WebViewWidget(controller: _controller))
        ],
      )));
}
