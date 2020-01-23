import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';
import 'package:elevator/src/data/repositories/order/order_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';

class HomeBloc extends BaseBloc<BaseBlocState, DoubleBlocState> {
  OrderRepository _orderRepository = injector.get();

  Stream<QuerySnapshot> inputOrders;

  @override
  DoubleBlocState get initialState => DoubleBlocState(EmptyBlocState(), null);

  Stream<QuerySnapshot> getInputOrders() => _orderRepository.getInputOrders();

  Stream<QuerySnapshot> getOutputOrders() => _orderRepository.getOutputOrders();
}
