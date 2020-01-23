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

class EnteredTab extends BaseStatefulWidget {
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
        RaisedButton(
          child: Text("dsf"),
          onPressed: addModel,
        ),
        Expanded(
          child: StreamBuilder(
            stream: _bloc.getInputOrders(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return getProgress(background: false);
              return ListView(
                children: snapshot.data.documents.map((document) {
                  return ListItem(Order.fromJsonMap(document.data));
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  void addModel() {
//    addCar();
//    addDriver();
    addOrder();
  }

  void addCar() {
    Car car = Car("Audi 5X", "АМ 8097 СТ", "АВ 8666 ВА");
    Car car2 = Car("ВАЗ 2101", "АМ 0000 СТ", "АВ 1111 ВА");
    OrderRepository orderRepository = injector.get();
    orderRepository.addCar(car);
    orderRepository.addCar(car2);
  }

  void addDriver() {
    Driver driver = Driver(
        "Іван", "Іванов", "+380673334455", "ivan@gmail.com", "invalidUrl");
    Driver driver2 = Driver(
        "Петро", "Петров", "+380674445566", "petro@gmail.com", "invalidUrl");
    OrderRepository orderRepository = injector.get();
    orderRepository.addDriver(driver);
    orderRepository.addDriver(driver2);
  }

  void addOrder() {
    List<Stamp> stamps = [
      Stamp("012345", false),
      Stamp("123456", false),
      Stamp("234567", false),
      Stamp("345678", false),
    ];

    List<Good> goods = [
      Good("Зерно 1", 5),
      Good("Зерно 2", 10),
      Good("Зерно 3", 15),
    ];

    Order order = Order(
        0,
        0,
        -1,
        stamps,
        goods,
        "Петренко Василь Іванович",
        "Вінниця",
        "Київ",
        "6wIc1TmJOGGJl4VLDUqb",
        "2bGoLq3cr1GbHlEq24Dk",
        DateTime.now().millisecondsSinceEpoch);
    Order order2 = Order(
        0,
        0,
        -1,
        stamps,
        goods,
        "Петренко Василь Іванович",
        "Вінниця",
        "Київ",
        "caccGTMhak9ZsMlBQ0Zv",
        "zdtqw08FOl64GQp7brLx",
        DateTime.now().millisecondsSinceEpoch);
    Order order3 = Order(
        1,
        0,
        -1,
        stamps,
        goods,
        "Петренко Василь Іванович",
        "Вінниця",
        "Київ",
        "6wIc1TmJOGGJl4VLDUqb",
        "zdtqw08FOl64GQp7brLx",
        DateTime.now().millisecondsSinceEpoch);
    Order order4 = Order(
        1,
        0,
        -1,
        stamps,
        goods,
        "Петренко Василь Іванович",
        "Вінниця",
        "Київ",
        "caccGTMhak9ZsMlBQ0Zv",
        "2bGoLq3cr1GbHlEq24Dk",
        DateTime.now().millisecondsSinceEpoch,
    );
    OrderRepository orderRepository = injector.get();
    orderRepository.addOrder(order);
    orderRepository.addOrder(order2);
    orderRepository.addOrder(order3);
    orderRepository.addOrder(order4);
  }
}
