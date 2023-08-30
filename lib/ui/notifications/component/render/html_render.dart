import 'package:flutter/material.dart';
import 'package:stake_calculator/domain/model/notification.dart' as xnot;
import 'package:stake_calculator/ui/core/widget/xstate.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:stake_calculator/util/dxt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlRender extends StatefulWidget {
  final xnot.Notification notification;

  const HtmlRender({super.key, required this.notification});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends XState<HtmlRender> {
  late final WebViewController _controller;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.notification.title ?? "",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 5.h,
            ),
            Text(
              widget.notification.description ?? "",
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
            Container(
              height: 24.h,
            ),
            Expanded(child: WebViewWidget(controller: _controller)),
            Container(
              height: 24.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  timeago
                      .format(widget.notification.createdAt ?? DateTime.now()),
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      );
}
