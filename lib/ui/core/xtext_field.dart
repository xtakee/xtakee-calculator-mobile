import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../commons.dart';

class XTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function()? onClear;
  final Function(String s)? onChanged;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool enable;
  final bool isSecret;
  final bool showSuffix;
  Widget? prefixIcon;
  final String label;
  String? errorText;
  final FocusNode? focusNode;
  final int lines;
  double? height;
  final TextInputType inputType;

  XTextField(
      {super.key,
      this.lines = 1,
      this.isSecret = false,
      this.focusNode,
      this.errorText,
      this.prefixIcon,
      this.textCapitalization = TextCapitalization.none,
      required this.label,
      this.height,
      this.showSuffix = true,
      this.inputType = TextInputType.number,
      this.enable = true,
      this.inputFormatters,
      this.onChanged,
      this.onClear,
      required this.controller}) {
    height = (height ?? 45).h;
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<XTextField> {
  bool showClear = false;
  bool showSecret = false;

  @override
  void initState() {
    widget.focusNode?.addListener(() {
      if (widget.focusNode!.hasFocus && widget.controller.text.isNotEmpty) {
        if(mounted) {
          setState(() {
          showClear = true;
        });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _child();

  _child() => TextField(
        maxLines: widget.lines,
        textCapitalization: widget.textCapitalization,
        focusNode: widget.focusNode,
        keyboardType: widget.inputType,
        controller: widget.controller,
        enabled: widget.enable,
        obscureText: widget.isSecret && !showSecret,
        style: const TextStyle(fontWeight: FontWeight.w500),
        inputFormatters: widget.inputFormatters,
        onChanged: (x) {
          if(mounted) {
            setState(() {
            showClear = x.isNotEmpty;
          });
          }
          if (widget.onChanged != null) {
            widget.onChanged!(x);
          }
        },
        decoration: InputDecoration(
          fillColor: primaryBackground,
          filled: true,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
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
          suffixIcon: Visibility(
            visible: showClear && widget.showSuffix,
            child: GestureDetector(
              onTap: () {
                if (!widget.isSecret) {
                  widget.focusNode?.requestFocus();
                  widget.controller.clear();
                  if (widget.onClear != null) {
                    widget.onClear!();
                  }
                } else {
                  if(mounted) {
                    setState(() {
                    showSecret = !showSecret;
                  });
                  }
                }
              },
              child: Icon(
                widget.isSecret
                    ? (showSecret
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined)
                    : Icons.clear,
                color: Colors.black45,
              ),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w, vertical: widget.lines == 1 ? 0 : 10.h),
        ),
      );
}
