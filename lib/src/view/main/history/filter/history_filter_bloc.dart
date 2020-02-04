import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';
import 'package:elevator/src/core/bloc/error_state.dart';
import 'package:elevator/src/data/repositories/history/history_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/responses/order/order.dart';

class DataChangedState extends BaseBlocState {}

class HistoryFilterBloc extends BaseBloc<BaseBlocState, DoubleBlocState> {
  @override
  DoubleBlocState get initialState => DoubleBlocState(EmptyBlocState(), null);

  HistoryRepository _historyRepository = injector.get();

  List<Order> input, output;

  void loadFilteredData(DateTime filter) async {
    try {
      if (input == null) {
        input = await _historyRepository.getInputOrdersFiltered(filter);
        add(DataChangedState());
      }
      if (output == null) {
        output = await _historyRepository.getOutputOrdersFiltered(filter);
        add(DataChangedState());
      }
    } catch (err) {
      add(ErrorState(err));
    }
  }
}
