import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/data/repositories/order/order_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/driver.dart';
import 'package:elevator/src/domain/responses/order/good.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/domain/responses/order/stamp.dart';
import 'package:elevator/src/view/main/home/home_bloc.dart';
import 'package:elevator/src/view/main/home/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class EnteredTab extends BaseStatefulWidget {
  final ScrollController hideButtonController;

  EnteredTab(this.hideButtonController);

  @override
  State<StatefulWidget> createState() {
    return _EnteredTabState();
  }
}

class _EnteredTabState extends BaseState<EnteredTab> {
  HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget getLayout() {
    return Column(
      children: <Widget>[
//        RaisedButton(
//          child: Text("dsf"),
//          onPressed: addModel,
//        ),
        Expanded(
          child: StreamBuilder(
            stream: _bloc.getInputOrders(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return getProgress(background: false);
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                controller: widget.hideButtonController,
                itemBuilder: (context, index) {
                  return ListItem(
                      Order.fromJsonMap(snapshot.data.documents[index].data));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void addModel() {
    addCar();
    addDriver();
    addOrder();
  }

  Driver driver = Driver(Uuid().v1(), "Іван", "Іванов", "+380673334455",
      "ivan@gmail.com", "invalidUrl");
  Driver driver2 = Driver(Uuid().v1(), "Петро", "Петров", "+380674445566",
      "petro@gmail.com", "invalidUrl");
  Car car = Car(Uuid().v1(), "Audi 5X", "АМ 8097 СТ", "АВ 8666 ВА");
  Car car2 = Car(Uuid().v1(), "ВАЗ 2101", "АМ 0000 СТ", "АВ 1111 ВА");

  void addCar() {
//    Car car = Car(Uuid().v1(), "Audi 5X", "АМ 8097 СТ", "АВ 8666 ВА");
//    Car car2 = Car(Uuid().v1(), "ВАЗ 2101", "АМ 0000 СТ", "АВ 1111 ВА");
    OrderRepository orderRepository = injector.get();
    orderRepository.addCar(car);
    orderRepository.addCar(car2);
  }

  void addDriver() {
//    Driver driver = Driver(Uuid().v1(), "Іван", "Іванов", "+380673334455",
//        "ivan@gmail.com", "invalidUrl");
//    Driver driver2 = Driver(Uuid().v1(), "Петро", "Петров", "+380674445566",
//        "petro@gmail.com", "invalidUrl");
    OrderRepository orderRepository = injector.get();
    orderRepository.addDriver(driver);
    orderRepository.addDriver(driver2);
  }

  void addOrder() {
    List<Stamp> stamps = [
      Stamp(Uuid().v1(), "012345", false),
      Stamp(Uuid().v1(), "123456", false),
      Stamp(Uuid().v1(), "234567", false),
      Stamp(Uuid().v1(), "345678", false),
    ];

    List<Good> goods = [
      Good(Uuid().v1(), "Зерно 1", 5),
      Good(Uuid().v1(), "Зерно 2", 10),
      Good(Uuid().v1(), "Зерно 3", 15),
    ];
    Order order = Order(
        Uuid().v1(),
        0,
        0,
        -1,
        stamps,
        goods,
        "Петренко Василь Іванович",
        "Вінниця",
        "Київ",
        DateTime.now().millisecondsSinceEpoch,
        driver,
        car);
    Order order2 = Order(
        Uuid().v1(),
        0,
        0,
        -1,
        stamps,
        goods,
        "Петренко Василь Іванович",
        "Вінниця",
        "Київ",
        DateTime.now().millisecondsSinceEpoch,
        driver2,
        car2);
    Order order3 = Order(
        Uuid().v1(),
        1,
        0,
        -1,
        stamps,
        goods,
        "Петренко Василь Іванович",
        "Вінниця",
        "Київ",
        DateTime.now().millisecondsSinceEpoch,
        driver,
        car2);
    Order order4 = Order(
        Uuid().v1(),
        1,
        0,
        -1,
        stamps,
        goods,
        "Петренко Василь Іванович",
        "Вінниця",
        "Київ",
        DateTime.now().millisecondsSinceEpoch,
        driver2,
        car);
    OrderRepository orderRepository = injector.get();
    orderRepository.addOrder(order);
    orderRepository.addOrder(order2);
    orderRepository.addOrder(order3);
    orderRepository.addOrder(order4);
  }
}
