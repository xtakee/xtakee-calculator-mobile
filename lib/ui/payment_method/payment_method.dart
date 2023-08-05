import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stake_calculator/ui/core/xcard.dart';
import 'package:stake_calculator/ui/payment_method/bloc/payment_method_bloc.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../domain/model/mandate.dart';
import '../../util/dimen.dart';
import '../../util/process_indicator.dart';
import '../commons.dart';
import '../core/xdialog.dart';
import '../core/xwarning_dialog.dart';

class PaymentMethod extends StatefulWidget {
  final Function(Mandate mandate) onSelected;
  final Function(String mandate) onDeleted;
  List<Mandate> mandates;
  final Mandate? selected;

  PaymentMethod(
      {super.key,
      required this.onDeleted,
      required this.mandates,
      required this.onSelected,
      this.selected});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PaymentMethod> {
  final bloc = PaymentMethodBloc();
  final ProcessIndicator _processIndicator = ProcessIndicator();

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
      bloc: bloc,
      listener: (_, state) {
        if (state is OnError) {
          _processIndicator.dismiss().then((_) {});
        } else if (state is OnLoading) {
          _processIndicator.show(context);
        } else if (state is OnDeleted) {
          _processIndicator.dismiss().then((_) {
            setState(() {
              widget.mandates
                  .removeWhere((element) => element.id == state.mandate);
            });

            widget.onDeleted(state.mandate);
            if (widget.mandates.isEmpty) AppRouter.goBack(context);
          });
        }
      },
      builder: (_, state) => Container(
            color: primaryBackground,
            padding: EdgeInsets.only(bottom: 16.h, top: 5.h),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Method",
                  textScaleFactor: scale,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  height: 10.h,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.mandates.length,
                    itemBuilder: (_, index) => _method(context,
                        mandate: widget.mandates[index],
                        isSelected:
                            widget.mandates[index].id == widget.selected?.id))
              ],
            ),
          ));

  Widget _method(BuildContext context,
          {required Mandate mandate, bool isSelected = false}) =>
      Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: XCard(
                        elevation: 0,
                        margin: EdgeInsets.only(top: 5.h),
                        onTap: () {
                          widget.onSelected(mandate);
                          AppRouter.goBack(context);
                        },
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  mandate.brand!.toCard(),
                                  height: 24.h,
                                ),
                                Container(
                                  height: 24.h,
                                  color: primaryBackground,
                                  width: 1.h,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${mandate.brand!.toTitleCase()} Card",
                                      textScaleFactor: scale,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "*********** ${mandate.last4}",
                                      textScaleFactor: scale,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Radio(
                              value: isSelected,
                              groupValue: true,
                              onChanged: (x) {},
                              activeColor: primaryColor,
                            )
                          ],
                        ))),
                Container(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: () => XDialog(context,
                          child: XWarningDialog(
                              onNegative: () {},
                              onPositive: () =>
                                  bloc.deleteMandate(mandate: mandate.id!),
                              description:
                                  "Are you sure you want to delete this card?",
                              positive: "Delete",
                              title: "Delete?"))
                      .show(),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 3.h,
              left: 0,
              child: widget.selected!.gateway!.toGateway())
        ],
      );
}
