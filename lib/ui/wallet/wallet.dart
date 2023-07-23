import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/ui/core/empty_page.dart';
import 'package:stake_calculator/ui/wallet/bloc/wallet_bloc.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

import '../../res.dart';
import '../../util/dimen.dart';
import '../../util/formatter.dart';
import '../commons.dart';
import 'component/transaction_item.dart';
import 'fund_wallet/fund_wallet.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Wallet> {
  final scrollController = ScrollController();

  static const collapsedBarHeight = 60.0;
  static const expandedBarHeight = 250.0;

  List<Transaction> transactions = [];

  bool isCollapsed = false;
  bool didAddFeedback = false;

  final bloc = WalletBloc();

  @override
  void initState() {
    super.initState();
    bloc.getStake();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: MultiBlocListener(
              listeners: [
                BlocListener(
                  listener: (_, state) {},
                  bloc: bloc,
                )
              ],
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  setState(() {
                    isCollapsed = scrollController.hasClients &&
                        scrollController.offset >
                            (expandedBarHeight - collapsedBarHeight);
                    if (isCollapsed && !didAddFeedback) {
                      HapticFeedback.mediumImpact();
                      didAddFeedback = true;
                    } else if (!isCollapsed) {
                      didAddFeedback = false;
                    }
                  });
                  return false;
                },
                child: _page(),
              )),
        ),
      );

  Widget _page() => Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: expandedBarHeight,
                collapsedHeight: collapsedBarHeight,
                forceMaterialTransparency: true,
                centerTitle: false,
                pinned: true,
                title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isCollapsed ? 1 : 0,
                    child: Row(
                      children: [
                        Text(
                          "Transactions",
                          textScaleFactor: scale,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ],
                    ) //CollapsedAppBarContent(movieDetails: movieDetails),
                    ),
                elevation: 0,
                backgroundColor: backgroundAccent,
                leading: const BackButton(
                  color: Colors.black,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding:
                        EdgeInsets.only(left: 32.w, top: 90.h, right: 32.w),
                    child: _wallet(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: Material(
                    elevation: 5,
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        15,
                      ),
                      topRight: Radius.circular(
                        15,
                      ),
                    ),
                    child: BlocBuilder(
                        bloc: bloc,
                        builder: (_, state) {
                          return transactions.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 10,
                                  itemBuilder: (_, state) {
                                    return TransactionItem(
                                      transaction: Transaction(),
                                    );
                                  })
                              : EmptyPage(
                                  description:
                                      "You do not have any transactions",
                                  ctaLabel: "Deposit",
                                  onClicked: () {});
                        }),
                  ),
                ),
              )
            ],
          )
        ],
      );

  Widget _wallet() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Coins",
                    textScaleFactor: scale,
                    style: const TextStyle(fontSize: 16),
                  ),
                  BlocBuilder(
                      bloc: bloc,
                      builder: (_, state) {
                        int balance = 0;
                        if (state is OnDataLoaded) {
                          balance = (state.stake.coins ?? 0) -
                              (state.stake.stakes ?? 0);
                        }

                        return Text(
                          Formatter.format(balance * 1.0),
                          textScaleFactor: scale,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 28,
                              fontWeight: FontWeight.w900),
                        );
                      }),
                  GestureDetector(
                    onTap: () =>
                        AppRouter.gotoWidget(const FundWallet(), context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      margin: EdgeInsets.only(top: 5.h),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.wallet,
                            color: Colors.white,
                          ),
                          Container(
                            width: 8.w,
                          ),
                          const Text(
                            "Buy Coins",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Opacity(
                opacity: 0.6,
                child: Lottie.asset(Res.wallet),
              )
            ],
          ),
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 10),
          //   child: Text(
          //     "Transactions",
          //     textScaleFactor: scale,
          //     style: const TextStyle(fontSize: 16),
          //   ),
          // )
        ],
      );
}
