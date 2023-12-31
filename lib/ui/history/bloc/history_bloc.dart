import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:stake_calculator/data/remote/model/bet_history_response.dart';

import '../../../domain/irepository.dart';
import '../../../domain/model/odd.dart';

part 'history_event.dart';

part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final _repository = GetIt.instance<IRepository>();

  void getHistory({required int limit, required int page}) =>
      add(GetHistory(limit: limit, page: page));

  HistoryBloc() : super(HistoryInitial()) {
    on<GetHistory>((event, emit) async {
      emit(OnLoading());
      try {
        final data =
            await _repository.getHistory(page: event.page, limit: event.limit);

        emit(OnDataLoaded(data: data));
      } catch (error) {
        emit(const OnError(message: "Error loading data"));
      }
    });
  }
}
