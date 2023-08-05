import 'package:flutter/material.dart';

import 'log.dart';

bool _isShowing = false;
String _dialogMessage = "";
BuildContext? _context;

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  final _State _dialog = _State();

  @override
  State<StatefulWidget> createState() => _dialog;

  update() {
    _dialog.update();
  }
}

class _State extends State<_Body> {
  update() {
    setState(() {});
  }

  @override
  void dispose() {
    _isShowing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.50),
      // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 45,
            width: 45,
            child: CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
          //Image.asset("assets/gifs/loader.gif", width: 128, height: 128,),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              _dialogMessage,
              softWrap: true,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          )
        ],
      )),
    );
  }
}

class ProcessIndicator {
  _Body? _dialog;

  // ProcessIndicator(BuildContext context) {
  //   _context = context;
  // }

  bool isShowing() {
    return _isShowing;
  }

  Future<bool> dismiss({bool force = false}) {
    return Future.delayed(Duration(milliseconds: force ? 0 : 150), () {
      if (_isShowing || force) {
        try {
          _isShowing = false;
          if (Navigator.of(_context!).canPop()) {
            Navigator.of(_context!).pop();
          }
          return Future.value(true);
        } catch (e) {
          return Future.value(false);
        }
      } else {
        return Future.value(false);
      }
    });
  }

  void show(BuildContext context, {String? message}) {
    _show(context, message: message ?? '');
  }

  void _show(BuildContext cntx, {String? message}) {
    _dialogMessage = message ?? '';
    if (!_isShowing) {
      _dialog = _Body();
      _isShowing = true;
      showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0.80),
        transitionDuration: const Duration(milliseconds: 0),
        context: cntx,
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          _context = context;

          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: _dialog!,
          );
        },
      );
    }
  }
}
