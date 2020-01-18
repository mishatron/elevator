import 'package:elevator/src/core/bloc/error_state.dart';

abstract class BaseBlocState {}

class DoubleBlocState extends BaseBlocState {
  final BaseBlocState lastSuccessState;
  final ErrorState errorState;

  DoubleBlocState(this.lastSuccessState, this.errorState);
}
