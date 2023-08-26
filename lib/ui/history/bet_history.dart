import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stake_calculator/ui/commons.dart';
import 'package:stake_calculator/ui/history/bloc/history_bloc.dart';
import 'package:stake_calculator/ui/history/component/empty_history_page.dart';
import 'package:stake_calculator/ui/history/component/history_item.dart';
import 'package:stake_calculator/util/dxt.dart';
import 'package:stake_calculator/util/expandable_panel.dart';

import '../../domain/model/history.dart';
import '../core/xchip.dart';

class BetHistory extends StatefulWidget {
  const BetHistory({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BetHistory> {
  final bloc = HistoryBloc();

  final _pageSize = 20;
  final List<History> _totalHistory = [];
  List<History> _history = [];
  final _tabsNames = ["All", "Wins", "Losses"];
  String selectedTab = "All";

  bool _showFilter = false;

  final PagingController<int, History> _pagingController =
      PagingController(firstPageKey: 0);

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      bloc.getHistory(limit: _pageSize, page: pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    _refreshController.dispose();
    super.dispose();
  }

  _filterList(String filter, List<History> items) {
    switch (filter) {
      case 'Wins':
        return items.wins();
      case 'Losses':
        return items.losses();
      default:
        return items;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryBackground,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "History",
                style: TextStyle(color: Colors.black),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _showFilter = !_showFilter;
                }),
                child: const Icon(Icons.filter_list),
              )
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: BlocConsumer(
              bloc: bloc,
              builder: (_, state) {
                if (state is OnDataLoaded) {
                  _history = state.data.docs ?? [];
                  final response = state.data;
                  final isLastPage = _history.length < _pageSize;
                  if (isLastPage) {
                    _pagingController
                        .appendLastPage(_filterList(selectedTab, _history));
                  } else {
                    _pagingController.appendPage(
                        _filterList(selectedTab, _history),
                        response.nextPage!.toInt());
                  }

                  _totalHistory.addAll(_history);
                  _refreshController.refreshCompleted();
                }

                if (state is OnError) {
                  _pagingController.error = state.message;
                }

                return Column(
                  children: [
                    _tabs(),
                    Expanded(
                        child: SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      onRefresh: () =>
                          bloc.getHistory(limit: _pageSize, page: 0),
                      child: _history.isEmpty
                          ? const EmptyHistoryPage()
                          : PagedListView.separated(
                              shrinkWrap: true,
                              builderDelegate:
                                  PagedChildBuilderDelegate<History>(
                                itemBuilder: (context, item, index) =>
                                    HistoryItem(history: item),
                              ),
                              pagingController: _pagingController,
                              separatorBuilder: (_, index) => Container(
                                height: 0,
                                color: primaryBackground,
                                margin: EdgeInsets.only(left: 32.w),
                              ),
                            ),
                    ))
                  ],
                );
              },
              listener: (_, state) {}),
        ),
      );

  Widget _tabs() => ExpandablePanel(
      expand: _showFilter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          XChip(
            choices: _tabsNames,
            wrapAlignment: WrapAlignment.center,
            defaultSelected: selectedTab,
            onSelectedChanged: (String choice) {
              setState(() {
                selectedTab = choice;
                int page = _pagingController.nextPageKey ?? 0;
                _pagingController.refresh();
                _pagingController.appendPage(
                    _filterList(selectedTab, _totalHistory), page);
              });
            },
          )
        ],
      ));
}
