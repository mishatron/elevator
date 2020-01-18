import 'package:flutter/services.dart';

import 'base_bloc.dart';
import 'base_bloc_state.dart';

enum MainBlocEvent { SET_PORTRAIT, SET_LANDSCAPE, SET_ALL }

abstract class MainBlocState extends BaseBlocState {}

class MainInitialState extends MainBlocState {}

class MainOrientationState extends MainBlocState {
  final List<DeviceOrientation> orientations;

  MainOrientationState(this.orientations);
}

class MainBloc extends BaseBloc<dynamic, MainBlocState> {
  @override
  MainBlocState get initialState => MainInitialState();

  @override
  Stream<MainBlocState> mapEventToState(dynamic event) async* {
    if (event == MainBlocEvent.SET_PORTRAIT) {
      yield MainOrientationState(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    } else if (event == MainBlocEvent.SET_LANDSCAPE) {
      yield MainOrientationState(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else if (event == MainBlocEvent.SET_PORTRAIT) {
      yield MainOrientationState([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    } else
      yield event;
  }
}
