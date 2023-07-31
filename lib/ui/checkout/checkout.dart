import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stake_calculator/domain/model/bundle.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/res.dart';
import 'package:stake_calculator/ui/checkout/bloc/checkout_bloc.dart';
import 'package:stake_calculator/ui/checkout/payment_successful.dart';
import 'package:stake_calculator/ui/core/xcard.dart';
import 'package:stake_calculator/ui/debit_card/debit_card.dart';
import 'package:stake_calculator/util/config.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/expandable_panel.dart';
import 'package:stake_calculator/util/formatter.dart';

import '../../util/dimen.dart';
import '../../util/process_indicator.dart';
import '../commons.dart';
import '../core/xbottom_sheet.dart';
import '../core/xbutton.dart';
import '../core/xdialog.dart';
import '../payment_method/payment_method.dart';

class Checkout extends StatefulWidget {
  final Bundle selectedBundle;

  const Checkout({super.key, required this.selectedBundle});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Checkout> {
  final bloc = CheckoutBloc();
  bool isNewCard = false;

  final payStack = PaystackPlugin();
  final ProcessIndicator _processIndicator = ProcessIndicator();

  @override
  void initState() {
    super.initState();

    payStack.initialize(publicKey: Config.shared.payStackPubKey);
    bloc.getMandates();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryBackground,
        bottomNavigationBar: SafeArea(
          child: BlocBuilder(
              bloc: bloc,
              builder: (_, state) => XButton(
                    enabled: bloc.mandates.isNotEmpty,
                    label: "Continue",
                    onClick: () =>
                        bloc.chargeMandate(bundle: widget.selectedBundle.id!),
                    margin:
                        EdgeInsets.only(bottom: 24.h, left: 16.w, right: 16.w),
                  )),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Checkout",
            textScaleFactor: scale,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
            child: BlocConsumer(
          bloc: bloc,
          listener: (_, state) {
            if (state is OnLoading) {
              _processIndicator.show(context);
            } else if (state is OnError) {
              _processIndicator.dismiss().then((value) {
                showSnack(context,
                    message: state.message, snackType: SnackType.ERROR);
              });
            } else if (state is OnSuccess) {
              _processIndicator.dismiss().then((value) {
                _processCardPayment(transaction: state.transaction);
              });
            } else if (state is OnComplete) {
              _processIndicator.dismiss().then((value) {
                XDialog(context,
                        child: const PaymentSuccessful(), dismissible: false)
                    .show();
              });
            } else if (state is OnMandates) {
              _processIndicator.dismiss().then((value) {});
            }
          },
          builder: (_, state) {
            return SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.05,
                  child: _amount(),
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: _paymentMethod())
              ],
            ));
          },
        )),
      );

  Widget _paymentMethod() => Container(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Method",
              textScaleFactor: scale,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.h),
            ),
            if (bloc.mandates.isNotEmpty)
              ExpandablePanel(
                  expand: true,
                  child: XCard(
                      elevation: 0,
                      borderSide: isNewCard
                          ? BorderSide.none
                          : BorderSide(color: primaryColor, width: 0.5.w),
                      padding:
                          EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() {
                              isNewCard = false;
                            }),
                            child: Row(
                              children: [
                                Image.asset(
                                  bloc.selected!.brand!.toCard(),
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
                                      "${bloc.selected!.brand!.toTitleCase()} Card",
                                      textScaleFactor: scale,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "*********** ${bloc.selected!.last4}",
                                      textScaleFactor: scale,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => XBottomSheet(context,
                                backgroundColor: primaryBackground,
                                child: PaymentMethod(
                                  mandates: bloc.mandates,
                                  selected: bloc.selected,
                                  onDeleted: (id) {
                                    setState(() {
                                      bloc.mandates.removeWhere(
                                          (element) => element.id == id);

                                      bloc.selected = bloc.mandates.first;
                                    });
                                  },
                                  onSelected: (mandate) {
                                    setState(() {
                                      bloc.selected = mandate;
                                    });
                                  },
                                )).show(),
                            child: Container(
                              margin: EdgeInsets.only(right: 10.w),
                              child: Text(
                                "Change",
                                textScaleFactor: scale,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor),
                              ),
                            ),
                          )
                        ],
                      ))),
            XCard(
                elevation: 0,
                borderSide: !isNewCard
                    ? BorderSide.none
                    : BorderSide(color: primaryColor, width: 0.5.w),
                onTap: () {
                  bloc.createTransaction(
                      bundle: widget.selectedBundle.id ?? "");
                },
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            color: primaryColor,
                          ),
                          Text(
                            " New Card",
                            textScaleFactor: scale,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryColor),
                          )
                        ],
                      ),
                    ),
                    ExpandablePanel(
                      expand: isNewCard,
                      child: const DebitCard(),
                    )
                  ],
                ))
          ],
        ),
      );

  Widget _amount() => XCard(
        elevation: 0,
        padding: EdgeInsets.all(16.h),
        margin: EdgeInsets.zero,
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 16.h),
              child: const Text(
                "Total",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                  color: colorFaintGreen,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    decoration: BoxDecoration(
                        color: colorGreen,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text("#",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  Container(
                    width: 5.w,
                  ),
                  Text(
                    Formatter.format((widget.selectedBundle.amount ?? 0) * 1.0,
                        symbol: ''),
                    textScaleFactor: scale,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: colorGreen),
                  )
                ],
              ),
            )
          ],
        ),
      );

  void _processCardPayment({required Transaction transaction}) {
    Charge charge = Charge()
      ..amount = (transaction.amount ?? 0).toInt() * 100
      ..currency = "NGN"
      ..reference = transaction.reference
      ..accessCode = transaction.auth
      ..email = transaction.account!.email;

    payStack
        .checkout(context,
            //fullscreen: true,
            method: CheckoutMethod.selectable, // Defaults to CheckoutMethod.selectable
            charge: charge,
            hideEmail: true,
            logo: SvgPicture.asset(
              Res.logo,
              width: 38,
              height: 38,
            ))
        .then((response) {
      if (response.status == true) {
        bloc.completeTransaction(reference: response.reference ?? "");
      }
    }).catchError((error) {
      showSnack(context, message: error.toString(), snackType: SnackType.ERROR);
    });
  }
}
