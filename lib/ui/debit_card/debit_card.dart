import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xtext_field.dart';
import 'package:stake_calculator/ui/debit_card/bloc/debit_card_bloc.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../res.dart';
import '../../util/dimen.dart';

class DebitCard extends StatefulWidget {
  const DebitCard({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DebitCard> {
  final bloc = DebitCardBloc();

  final cardNumberController = TextEditingController();
  final cardCvvController = TextEditingController();
  final cardNameController = TextEditingController();
  final cardExpiryController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
      bloc: bloc,
      listener: (BuildContext context, Object? state) {},
      builder: (_, state) {
        return Column(
          children: [
            Container(
              height: 5.h,
            ),
            Container(
              margin: EdgeInsets.only(top: 10.w),
              child: Column(
                children: [
                  XTextField(
                      label: "Card Number", controller: cardNumberController),
                  Container(
                    height: 16.h,
                  ),
                  XTextField(
                      label: "Card Name", controller: cardNameController, inputType: TextInputType.name,),
                  Container(
                    height: 16.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: XTextField(
                            label: "Expiry Date",
                            controller: cardExpiryController),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: XTextField(
                            label: "CVV", controller: cardCvvController),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 24.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Secured by ",
                  textScaleFactor: scale,
                  style: const TextStyle(fontSize: 14),
                ),
                SvgPicture.asset(
                  Res.paystack,
                  width: 14,
                  height: 14,
                )
              ],
            ),
            Container(
              height: 10.h,
            ),
          ],
        );
      });
}
