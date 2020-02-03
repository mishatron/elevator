import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';
import 'package:elevator/src/data/repositories/order/order_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:flutter/material.dart';


enum Events {
  CANCEL,
  ON_NEXT_TO_DRIVER_INFO,
  ON_BACK_TO_CAR_INFO,
  ON_NEXT_TO_ORDER_INFO,
  ON_BACK_TO_DRIVER_INFO,
  CREATE_ORDER,
}

class CreateOrderBloc extends BaseBloc<BaseBlocState, DoubleBlocState> {

  ValueNotifier<bool> isEmptyField = ValueNotifier(false);
  StreamController streamController;

  OrderRepository _orderRepository = injector.get();


  CreateOrderBloc() {
    streamController = StreamController();
  }

  @override
  Future<void> close() {
    streamController.close();
    return super.close();
  }

  @override
  DoubleBlocState get initialState => DoubleBlocState(EmptyBlocState(), null);

  Stream<QuerySnapshot> getCars() => _orderRepository.getCars();


  bool isCarInfoValidate() {

  }

  bool isDriverInfoValidate() {

  }

  bool isOrderInfoValidate() {

  }

  bool isCreateOrderValidate() {

    return (isCarInfoValidate() && isDriverInfoValidate() && isOrderInfoValidate());
  }
}
