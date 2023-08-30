import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xtext_field.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../domain/model/odd.dart';

class StakeItem extends StatelessWidget {
  final TextEditingController tagController;
  final TextEditingController oddController;
  final Function(Odd odd, int position) onDelete;
  final Function(Odd odd, int position, bool isPair) onUpdate;
  final bool isOnlyItem;
  final FocusNode? oddFocusNode;
  final FocusNode? tagFocusNode;
  final bool isLast;
  final bool isPair;
  final int position;

  const StakeItem(
      {super.key,
      required this.isLast,
      this.oddFocusNode,
      this.tagFocusNode,
      required this.position,
      required this.onDelete,
      required this.onUpdate,
      required this.isOnlyItem,
      required this.oddController,
      required this.tagController,
      required this.isPair});

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Checkbox(
                  value: isPair,
                  activeColor: primaryColor,
                  onChanged: isLast
                      ? null
                      : (x) => onUpdate(
                          Odd(
                              odd: double.parse(oddController.text.isEmpty
                                  ? "0.00"
                                  : oddController.text),
                              name: tagController.text,
                              isPair: x ?? false),
                          position,
                          x ?? false)),
              Expanded(
                child: XTextField(
                    inputType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    controller: tagController,
                    focusNode: tagFocusNode,
                    label: "Tag",
                    onChanged: (s) {
                      String odd = oddController.text;
                      onUpdate(
                          Odd(
                              odd: double.parse(odd.isEmpty ? "0.00" : odd),
                              name: s,
                              isPair: isPair),
                          position,
                          isPair);
                    }),
              ),
              Container(
                width: 16.h,
              ),
              Expanded(
                child: XTextField(
                    enable: true,
                    label: "Odd",
                    focusNode: oddFocusNode,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]+.?[0-9]*'))
                    ],
                    onClear: () {
                      onUpdate(
                          Odd(
                              odd: 0.00,
                              name: tagController.text,
                              isPair: isPair),
                          position,
                          isPair);
                    },
                    onChanged: (s) {
                      onUpdate(
                          Odd(
                              odd: double.parse(s.isEmpty ? "0" : s),
                              name: tagController.text,
                              isPair: isPair),
                          position,
                          isPair);
                    },
                    inputType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: oddController),
              ),
              Container(
                width: 16.h,
              ),
              if (!isOnlyItem)
                GestureDetector(
                  onTap: () {
                    onDelete(
                        Odd(
                            odd: double.parse(oddController.text.isEmpty
                                ? "0.00"
                                : oddController.text),
                            name: tagController.text),
                        position);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Color(0xFFea3815),
                  ),
                )
              else
                const Icon(
                  Icons.local_fire_department_sharp,
                  color: primaryColor,
                ),
            ],
          ),
          Container(
            height: 10.h,
          )
        ],
      ));
}
