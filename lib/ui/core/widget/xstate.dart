import 'package:flutter/material.dart';

import '../../../util/process_indicator.dart';
import '../../commons.dart';

abstract class XState<T extends StatefulWidget> extends State<T> {
  final ProcessIndicator _processIndicator = ProcessIndicator();

  showProcessIndicator() => _processIndicator.show(context);

  Future<bool> dismissProcessIndicator() => _processIndicator.dismiss();

  void showMessage(
          {required String message, SnackType snackType = SnackType.MESSAGE}) =>
      showSnack(context, message: message, snackType: snackType);
}