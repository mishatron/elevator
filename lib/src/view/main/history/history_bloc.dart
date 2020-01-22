import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';

class HistoryBloc extends BaseBloc<BaseBlocState, DoubleBlocState> {
  @override
  DoubleBlocState get initialState => DoubleBlocState(EmptyBlocState(), null);
}
