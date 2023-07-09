import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/util/dxt.dart';

class XSwitch extends StatelessWidget {
  final Color activeColor;
  final String label;
  final bool value;
  final Function(bool status) onChanged;

  const XSwitch(
      {super.key,
      required this.label,
      required this.value,
      this.activeColor = Colors.greenAccent,
      required this.onChanged});

  @override
  Widget build(BuildContext context) =>  Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
      Container(
        width: 5.w,
      ),
      Transform.scale(
        scale: 0.8,
        child: Switch(
            value: value,
            activeColor: activeColor,
            onChanged: (status) {
              onChanged(status);
            }),
      )
    ],
  );
}

