import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:elevator/src/core/bloc/error_state.dart';

import 'base_bloc_state.dart';

abstract class BaseBloc<Event, State extends BaseBlocState>
    extends Bloc<Event, State> {
  BaseBlocState lastSuccessfulState;

  @override
  Stream<State> mapEventToState(dynamic event) async* {
    if (event is! ErrorState) {
      lastSuccessfulState = event;
      yield DoubleBlocState(event, null) as State;
    } else {
      yield DoubleBlocState(lastSuccessfulState, event) as State;
    }
  }
}
