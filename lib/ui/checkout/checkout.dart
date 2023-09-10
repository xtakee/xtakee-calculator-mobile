import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:paystack_standard/paystack_standard.dart';
import 'package:stake_calculator/domain/model/bundle.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/ui/checkout/bloc/checkout_bloc.dart';
import 'package:stake_calculator/ui/checkout/component/payment_processor.dart';
import 'package:stake_calculator/ui/checkout/component/payment_successful.dart';
import 'package:stake_calculator/ui/checkout/component/payment_timeout.dart';
import 'package:stake_calculator/ui/core/xcard.dart';
import 'package:stake_calculator/util/config.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/expandable_panel.dart';
import 'package:stake_calculator/util/formatter.dart';
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
  bool isLoading = false;

  final ProcessIndicator _processIndicator = ProcessIndicator();

  @override
  void initState() {
    super.initState();
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
                    enabled: bloc.mandates.isNotEmpty && !isLoading,
                    loading: isLoading,
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
          title: const Text(
            "Checkout",
            style: TextStyle(color: Colors.black),
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
              _processIndicator.dismiss().then((_) {
                if (state.transaction.gateway == Processor.paystack.name) {
                  _processPayStackPayment(transaction: state.transaction);
                } else if (state.transaction.gateway ==
                    Processor.flutterwave.name) {
                  _processFlwPayment(transaction: state.transaction);
                }
              });
            } else if (state is OnComplete) {
              _processIndicator.dismiss().then((_) {
                XDialog(context,
                        child: const PaymentSuccessful(), dismissible: false)
                    .show();
              });
            } else if (state is OnMandates) {
              _processIndicator.dismiss().then((value) {});
            } else if (state is OnTimeOutError) {
              _processIndicator.dismiss().then((_) =>
                  XDialog(context, child: const PaymentTimeout()).show());
            } else if (state is OnPaymentGateway) {
              _processIndicator.dismiss().then((_) => XBottomSheet(context,
                  backgroundColor: primaryBackground,
                  child: PaymentProcessor(
                    gateways: state.gateways,
                    onSelected: (x) {
                      bloc.createTransaction(
                          bundle: widget.selectedBundle.id ?? "",
                          gateway: x.name);
                    },
                  )).show());
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
                    child: Stack(
                      children: [
                        _paymentMethod(),
                        if (isLoading)
                          Positioned.fill(
                              child: Container(
                            color: primaryBackground.withOpacity(0.5),
                          ))
                      ],
                    ))
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
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h),
            ),
            if (bloc.mandates.isNotEmpty)
              ExpandablePanel(
                  expand: true,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: XCard(
                            elevation: 0,
                            borderSide: isNewCard
                                ? BorderSide.none
                                : BorderSide(color: primaryColor, width: 0.5.w),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 8.w),
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
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${bloc.selected!.brand!.toTitleCase()} Card",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "*********** ${bloc.selected!.last4}",
                                            style: TextStyle(
                                                fontSize: 14.sp,
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

                                            bloc.selected =
                                                bloc.mandates.firstOrNull;
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
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                      if (bloc.selected!.gateway != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: bloc.selected!.gateway!.toGateway(),
                        )
                    ],
                  )),
            XCard(
                elevation: 0,
                borderSide: !isNewCard
                    ? BorderSide.none
                    : BorderSide(color: primaryColor, width: 0.5.w),
                onTap: () => bloc.getGateways(),
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
                            " New Payment Method",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: primaryColor),
                          )
                        ],
                      ),
                    ),
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
              child: Text(
                "Total",
                style: TextStyle(fontSize: 16.sp),
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
                    child: Text("#",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  Container(
                    width: 5.w,
                  ),
                  Text(
                    Formatter.format((widget.selectedBundle.totalAmount) * 1.0,
                        symbol: ''),
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: colorGreen),
                  )
                ],
              ),
            )
          ],
        ),
      );

  void _setLoading(bool status) => setState(() {
        isLoading = status;
      });

  void _processFlwPayment({required Transaction transaction}) {
    final Customer customer = Customer(email: transaction.account!.email!);

    final Flutterwave flw = Flutterwave(
        context: context,
        publicKey: Config.shared.flwPubKey,
        currency: "NGN",
        txRef: transaction.reference!,
        amount: (transaction.amount ?? 0).toString(),
        customer: customer,
        paymentOptions: "ussd, card, barter, payattitude",
        customization: Customization(),
        isTestMode: false,
        redirectUrl: "url");

    _setLoading(true);

    flw.charge().then((response) {
      _setLoading(false);
      if (response.success == true || response.status == "completed") {
        bloc.completeTransaction(reference: response.txRef ?? "");
      }
    }).catchError((error) {
      _setLoading(false);
      showSnack(context, message: error.toString(), snackType: SnackType.ERROR);
    });
  }

  void _processPayStackPayment({required Transaction transaction}) {
    PaystackStandard(context)
        .checkout(checkoutUrl: transaction.checkoutUrl)
        .then((response) {
      if (response.success) {
        bloc.completeTransaction(reference: transaction.reference ?? "");
      }
    });
  }
}
