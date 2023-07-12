import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/util/dxt.dart';

class XSwitch extends StatelessWidget {
  final Color activeColor;
  final String label;
  final bool value;
  final MainAxisAlignment alignment;
  final Function(bool status) onChanged;

  const XSwitch(
      {super.key,
      this.alignment = MainAxisAlignment.spaceBetween,
      required this.label,
      required this.value,
      this.activeColor = Colors.greenAccent,
      required this.onChanged});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: alignment,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Container(
            width: 5.w,
          ),
          Transform.scale(
            scaleY: 0.8,
            scaleX: 0.9,
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
