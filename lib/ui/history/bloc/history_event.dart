part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class GetHistory extends HistoryEvent {
  final int limit;
  final int page;

  const GetHistory({required this.limit, required this.page});

  @override
  List<Object?> get props =>[limit, page];
}
