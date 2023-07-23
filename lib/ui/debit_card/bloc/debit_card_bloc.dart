import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'debit_card_event.dart';
part 'debit_card_state.dart';

class DebitCardBloc extends Bloc<DebitCardEvent, DebitCardState> {
  DebitCardBloc() : super(DebitCardInitial()) {
    on<DebitCardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
