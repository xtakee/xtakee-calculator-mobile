import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stake_calculator/domain/model/previous_stake.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xtext_field.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../domain/model/odd.dart';
import '../../util/log.dart';

class StakeItem extends StatelessWidget {
  final TextEditingController tagController;
  final TextEditingController oddController;
  final PreviousStake previousStake;
  final Function(Odd odd, int position) onDelete;
  final Function(Odd odd, int position) onUpdate;
  final bool isOnlyItem;
  final bool isLast;
  final int position;

  const StakeItem(
      {super.key,
      required this.isLast,
      required this.position,
      required this.onDelete,
      required this.onUpdate,
      required this.isOnlyItem,
      required this.previousStake,
      required this.oddController,
      required this.tagController});

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(left: 16.w, right: 10.w, bottom: 10.h),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: XTextField(
                    inputType: TextInputType.text,
                    controller: tagController,
                    label: "Tag",
                    onChanged: (s) {
                      String odd = oddController.text;
                      onUpdate(
                          Odd(
                              odd: double.parse(odd.isEmpty ? "0.00" : odd),
                              name: s),
                          position);
                    }),
              ),
              Container(
                width: 16.h,
              ),
              Expanded(
                child: XTextField(
                    enable: true,
                    label: "Odd",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]+.?[0-9]*'))
                    ],
                    onChanged: (s) {
                      Log.d(s);
                      onUpdate(
                          Odd(
                              odd: double.parse(s.isEmpty ? "0" : s),
                              name: tagController.text),
                          position);
                    },
                    inputType: TextInputType.number,
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
                            tag: tagController.text),
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
          // if (!isLast)
          //   Container(
          //     height: 2.h,
          //     color: Color(0xFFE0E0E0),
          //     margin: EdgeInsets.only(
          //         top: 16.h,
          //         bottom: 5.h,
          //         left: 64.w, right: 64.w),
          //   )
        ],
      ));
}
