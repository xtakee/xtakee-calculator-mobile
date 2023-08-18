import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stake_calculator/domain/model/transaction.dart';
import 'package:stake_calculator/ui/payment/bloc/payment_bloc.dart';
import 'package:stake_calculator/ui/payment/component/transaction_item.dart';
import 'package:stake_calculator/util/dxt.dart';

import '../../util/dimen.dart';
import '../history/component/empty_history_page.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Payment> {
  final bloc = PaymentBloc();
  final _pageSize = 20;
  List<Transaction> _transactions = [];

  final PagingController<int, Transaction> _pagingController =
      PagingController(firstPageKey: 0);

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      bloc.getTransactions(page: pageKey, limit: _pageSize);
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Transactions",
            style: TextStyle(color: Colors.black, fontSize: 18.sp),
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: BlocConsumer(
              bloc: bloc,
              builder: (_, state) {
                if (state is OnDataLoaded) {
                  _transactions = state.data.docs ?? [];
                  _refreshController.refreshCompleted();

                  _transactions = state.data.docs ?? [];
                  final response = state.data;
                  final isLastPage = _transactions.length < _pageSize;
                  if (isLastPage) {
                    _pagingController.appendLastPage(_transactions);
                  } else {
                    _pagingController.appendPage(
                        _transactions, response.nextPage!.toInt());
                  }

                  _refreshController.refreshCompleted();
                }

                if (state is OnError) {
                  _pagingController.error = state.message;
                }

                return SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  onRefresh: () => bloc.getTransactions(limit: 20, page: 0),
                  child: _transactions.isEmpty
                      ? const EmptyHistoryPage(
                          text: "You have not made any payment",
                        )
                      : PagedListView.separated(
                          shrinkWrap: true,
                          builderDelegate:
                              PagedChildBuilderDelegate<Transaction>(
                                  itemBuilder: (context, item, index) =>
                                      TransactionItem(transaction: item)),
                          separatorBuilder: (BuildContext context, int index) =>
                              Container(
                            height: 0.5.h,
                            color: Colors.black12.withOpacity(0.1),
                            margin: EdgeInsets.only(left: 32.w),
                          ),
                          pagingController: _pagingController,
                        ),
                );
              },
              listener: (_, state) {}),
        ),
      );
}
