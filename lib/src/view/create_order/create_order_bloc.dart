import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';
import 'package:elevator/src/core/bloc/error_state.dart';
import 'package:elevator/src/core/bloc/loading_state.dart';
import 'package:elevator/src/core/bloc/no_loading_state.dart';
import 'package:elevator/src/data/repositories/order/order_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
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
  Order order = Order();

  OrderRepository _orderRepository;

  CreateOrderBloc() {
    _orderRepository = injector.get();
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

  Stream<QuerySnapshot> getDrivers() => _orderRepository.getDrivers();

  

  void createOrder() {
    add(LoadingState());
    try {
      _orderRepository.addCar(order.car).then((car) {
        _orderRepository.addDriver(order.driver).then((driver) {
          _orderRepository.addOrder(order);
        });
      });
    } catch (err) {
      add(ErrorState(err));
    }
  }

  bool isCarInfoValidate() {
    if (order.car == null) return false;
    order.car.carNumber = order.car.carNumber.trim();
    order.car.carModel = order.car.carModel.trim();
    order.car.trailerNumber = order.car.trailerNumber.trim();
    return (order.car.carNumber.isNotEmpty &&
        order.car.carModel.isNotEmpty &&
        order.car.trailerNumber.isNotEmpty);
  }

  bool isDriverInfoValidate() {
    if (order.driver == null) return false;
    order.driver.firstName = order.driver.firstName.trim();
    order.driver.lastName = order.driver.lastName.trim();
    order.driver.phone = order.driver.phone.trim();
    order.driver.email = order.driver.email.trim();
    return (order.driver.firstName.isNotEmpty &&
        order.driver.lastName.isNotEmpty &&
        order.driver.phone.isNotEmpty &&
        order.driver.email.isNotEmpty);
  }

  bool isOrderInfoValidate() {
    order.from = order.from.trim();
    order.to = order.to.trim();
    return (order.owner.isNotEmpty &&
        order.from.isNotEmpty &&
        order.to.isNotEmpty &&
        order.stamps.isNotEmpty &&
        order.goods.isNotEmpty);
  }

  bool isCreateOrderValidate() {
    return (isCarInfoValidate() &&
        isDriverInfoValidate() &&
        isOrderInfoValidate());
  }
}
