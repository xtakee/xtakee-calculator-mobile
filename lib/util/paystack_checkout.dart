import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../ui/core/xdialog.dart';
import '../ui/core/xwarning_dialog.dart';

class PaystackCheckout extends StatefulWidget {
  final String path;

  const PaystackCheckout({super.key, required this.path});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PaystackCheckout> {
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
              if (mounted) {
                setState(() {
                  _percent = (progress / 100);
                });
              }
            },
            onUrlChange: (UrlChange urlChange) {},
            onPageStarted: (String url) {
              if (url.contains("xtakee.com/?trxref=") ||
                  url.contains("xtakee.com?trxref=")) {
                AppRouter.goBack(context, result: true);
              } else if (url.contains("xtakee.com")) {
                AppRouter.goBack(context, result: false);
              }
            },
            onPageFinished: (String url) {
              _percent = 1;
              _hideCancelButton();
            }),
      )
      ..loadRequest(Uri.parse(widget.path));
  }

  _hideCancelButton() async {
    // const hideButtonScript = '''
    //   const cancelButton = Array.from(document.querySelectorAll('button span.text')).find(span => span.textContent === 'Cancel Payment');
    //   if (cancelButton) {
    //     cancelButton.parentElement.style.display = 'none';
    //   }
    // ''';
    const hideButtonScript = '''
      const waitForVisibleButtonMobile = async () => {
        while (true) {
          const cancelButton = Array.from(document.querySelectorAll('button span.text')).find(span => span.textContent === 'Cancel Payment');
          if (cancelButton) {
            return true;
          }
          await new Promise(resolve => requestAnimationFrame(resolve));
        }
      };
      
      const waitForVisibleButtonWeb = async () => {
        while (true) {
          const closeButton = document.querySelectorAll('button[aria-label="Close"]')[0];
          if (closeButton) {
            return true;
          }
          await new Promise(resolve => requestAnimationFrame(resolve));
        }
      };

   waitForVisibleButtonWeb().then(() => {
        const closeButton = document.querySelectorAll('button[aria-label="Close"]')[0];
        if (closeButton) {
          closeButton.style.display = 'none';
        }
      });
      
      waitForVisibleButtonMobile().then(() => {
          const cancelButton = Array.from(document.querySelectorAll('button span.text')).find(span => span.textContent === 'Cancel Payment');
          if (cancelButton) {
            cancelButton.parentElement.style.display = 'none';
          }
      });
    ''';

    await _controller.runJavaScript(hideButtonScript);
  }

  _showCancelWarning() => XDialog(context,
          child: XWarningDialog(
              onNegative: () {},
              onPositive: () => AppRouter.goBack(context),
              description:
                  "Are you sure? You are about to cancel the transaction",
              positive: "Ok",
              title: "Cancel Transaction?"))
      .show();

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: primaryBackground,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "Paystack Checkout",
              style: TextStyle(color: Colors.black),
            ),
            GestureDetector(
              onTap: () => _showCancelWarning(),
              child: const Icon(Icons.close),
            )
          ])),
      body: WillPopScope(
          onWillPop: () async => _showCancelWarning(),
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
          ))));
}
