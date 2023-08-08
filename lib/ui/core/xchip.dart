import 'package:flutter/material.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/game_type.dart';

class XChip extends StatelessWidget {
  final List<String> choices;
  final String defaultSelected;
  final Function(String choice) onSelectedChanged;
  final WrapAlignment wrapAlignment;
  final WrapCrossAlignment wrapCrossAlignment;

  const XChip(
      {super.key,
      required this.choices,
      this.wrapAlignment = WrapAlignment.start,
      this.wrapCrossAlignment = WrapCrossAlignment.start,
      required this.defaultSelected,
      required this.onSelectedChanged});

  @override
  Widget build(BuildContext context) => Wrap(
        alignment: wrapAlignment,
        crossAxisAlignment: wrapCrossAlignment,
        spacing: 16.h,
        children: _chips(),
      );

  List<Widget> _chips() {
    List<Widget> chips = [];
    for (var choice in choices) {
      chips.add(ChoiceChip(
        side: const BorderSide(color: primaryBackground),
        backgroundColor: primaryBackground,
        label: Text(choice),
        selected: defaultSelected == choice,
        onSelected: (status) {
          onSelectedChanged(choice);
        },
        selectedColor: primaryColor.withOpacity(0.1),
      ));
    }
    return chips;
  }
}
