import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../commons.dart';

class XTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String s)? onChanged;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool enable;
  final bool showSuffix;
  final String label;
  final FocusNode? focusNode;
  final int lines;
  double? height;
  final TextInputType inputType;

  XTextField(
      {super.key,
      this.lines = 1,
      this.focusNode,
      this.textCapitalization = TextCapitalization.none,
      required this.label,
      this.height,
      this.showSuffix = true,
      this.inputType = TextInputType.number,
      this.enable = true,
      this.inputFormatters,
      this.onChanged,
      required this.controller}) {
    height = (height ?? 45).h;
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<XTextField> {
  bool showClear = false;

  @override
  Widget build(BuildContext context) => (widget.lines == 1)
      ? SizedBox(
          height: widget.height,
          child: _child(),
        )
      : _child();

  _child() => TextField(
        maxLines: widget.lines,
        textCapitalization: widget.textCapitalization,
        focusNode: widget.focusNode,
        keyboardType: widget.inputType,
        controller: widget.controller,
        enabled: widget.enable,
        style: const TextStyle(fontWeight: FontWeight.w500),
        inputFormatters: widget.inputFormatters,
        onChanged: (x) {
          setState(() {
            showClear = x.isNotEmpty;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(x);
          }
        },
        decoration: InputDecoration(
          fillColor: primaryBackground,
          filled: true,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0.5, color: primaryColor),
              borderRadius: BorderRadius.circular(5)),
          label: Text(
            widget.label,
            style: const TextStyle(color: Colors.black),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5)),
          suffixIcon: GestureDetector(
            onTap: () {
              if (showClear) {
                widget.focusNode?.requestFocus();
                widget.controller.clear();
              }
            },
            child: Icon(
              Icons.clear,
              color: showClear ? Colors.black45 : primaryBackground,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: widget.lines == 1 ? 0 : 10.h),
        ),
      );
}
