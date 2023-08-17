import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/istake_repository.dart';
import '../../../../domain/model/odd.dart';
import '../../../../domain/model/stake.dart';

part 'pip_event.dart';
part 'pip_state.dart';

class PipBloc extends Bloc<PipEvent, PipState> {

  final _repository = GetIt.instance<IStakeRepository>();

  void getStake() => add(GetStake());
  void getTags() => add(GetTags());

  PipBloc() : super(PipInitial()) {
    on<GetStake>((event, emit) async {
      final stake = await _repository.getStake(cached: true);
      final tags = await _repository.getTags();
      emit(OnDataLoaded(stake: stake, tags: tags));
    });
  }
}
