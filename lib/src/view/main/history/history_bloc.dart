import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';
import 'package:elevator/src/data/repositories/history/history_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';

class HistoryBloc extends BaseBloc<BaseBlocState, DoubleBlocState> {
  @override
  DoubleBlocState get initialState => DoubleBlocState(EmptyBlocState(), null);

  HistoryRepository _historyRepository = injector.get();

  Stream<QuerySnapshot> getInputOrders() => _historyRepository.getInputOrders();

  Stream<QuerySnapshot> getOutputOrders() => _historyRepository.getOutputOrders();
}
