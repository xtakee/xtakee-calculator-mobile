import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stake_calculator/ui/checkout/checkout.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/core/xbutton.dart';
import 'package:stake_calculator/ui/core/xcard.dart';
import 'package:stake_calculator/ui/core/xchip.dart';
import 'package:stake_calculator/ui/wallet/fund_wallet/bloc/fund_wallet_bloc.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/formatter.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../../domain/model/bundle.dart';
import '../../../util/dimen.dart';
import '../../../util/process_indicator.dart';

class FundWallet extends StatefulWidget {
  const FundWallet({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<FundWallet> {
  final ProcessIndicator _processIndicator = ProcessIndicator();
  final bloc = FundWalletBloc();
  List<Bundle> bundles = [];
  Bundle? selectedBundle;
  double amount = 0;
  int value = 0;

  @override
  void initState() {
    super.initState();
    if (mounted) bloc.getBundles();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
      bloc: bloc,
      listener: (_, state) {
        if (state is OnLoading) {
          _processIndicator.show(context);
        }
        if (state is OnDataLoaded) {
          bundles = state.bundles;
          selectedBundle = bundles.firstOrNull;
          amount = (selectedBundle?.amount ?? 0) * 1.0;
          value = (selectedBundle?.value ?? 0);
          _processIndicator.dismiss();
        } else if (state is OnError) {
          _processIndicator.dismiss().then((value) => showSnack(context,
              message: "An error occurred. Kindly try again", snackType: SnackType.ERROR));
        }
      },
      builder: (_, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            // systemOverlayStyle: const SystemUiOverlayStyle(
            //   // Status bar color
            //   statusBarColor: primaryColor,
            //   // Status bar brightness (optional)
            //   statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            //   statusBarBrightness: Brightness.light, // For iOS (dark icons)
            // ),
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: Text(
              "Buy Coins",
              textScaleFactor: scale,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: primaryBackground,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [_amount(), _bundles()],
                ),
                XButton(
                  label: "Continue",
                  enabled: selectedBundle != null,
                  onClick: () => AppRouter.gotoWidget(
                      Checkout(selectedBundle: selectedBundle!), context),
                  margin: EdgeInsets.only(bottom: 24.h, right: 16.w, left: 16.w),
                )
              ],
            ),
          ),
        );
      });

  Widget _amount() => Container(
        margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: XCard(
          elevation: 0,
          padding: EdgeInsets.all(16.h),
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Amount: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      Formatter.format(amount),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
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
                      value.toString(),
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
        ),
      );

  Widget _bundles() => XCard(
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(16.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      elevation: 0,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16.h),
            alignment: Alignment.topLeft,
            child: Text(
              "Select a bundle to continue",
              textScaleFactor: scale,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          XChip(
            choices: bundles.map((e) => e.value.toString()).toList(),
            defaultSelected: (selectedBundle?.value ?? 0).toString(),
            onSelectedChanged: (String choice) {
              setState(() {
                selectedBundle = bundles.firstWhere(
                    (element) => element.value.toString() == choice);

                if (selectedBundle != null) {
                  amount = (selectedBundle?.amount ?? 0) * 1.0;
                  value = (selectedBundle?.value ?? 0);
                }
              });
            },
          )
        ],
      ));
}
