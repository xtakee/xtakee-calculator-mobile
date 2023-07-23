import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stake_calculator/ui/history/bloc/history_bloc.dart';
import 'package:stake_calculator/ui/history/component/empty_history_page.dart';
import 'package:stake_calculator/ui/history/component/history_item.dart';

import '../../domain/model/history.dart';
import '../../util/dimen.dart';
import '../commons.dart';

class BetHistory extends StatefulWidget {
  const BetHistory({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BetHistory> {
  final bloc = HistoryBloc();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    bloc.getHistory(limit: 20, page: 0);
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "History",
            textScaleFactor: scale,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: BlocConsumer(
              bloc: bloc,
              builder: (_, state) {
                List<History> history = [];

                if (state is OnDataLoaded) {
                  history = state.data.docs ?? [];
                  _refreshController.refreshCompleted();
                }

                return SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  onRefresh: () => bloc.getHistory(limit: 20, page: 1),
                  child: history.isEmpty
                      ? (state is OnLoading)
                      ? Container()
                      : const EmptyHistoryPage()
                      : ListView.builder(
                      shrinkWrap: true,
                      itemCount: history.length,
                      itemBuilder: (_, index) =>
                          HistoryItem(history: history[index])),
                );
              },
              listener: (_, state) {}),
        ),
      );
}
