import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/res/values/colors.dart';
import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/driver.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/view/create_order/create_order_bloc.dart';
import 'package:elevator/src/view/custom/BaseButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrderScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateOrderScreenState();
  }
}

class _CreateOrderScreenState extends BaseStatefulScreen<CreateOrderScreen>
    with BaseBlocListener {
  CreateOrderBloc _bloc = CreateOrderBloc();
  Widget _myAnimatedWidget;

  Widget _carInfo = CarInfo();
  Widget _driverInfo = DriverInfo();
  Widget _orderInfo = OrderInfo();

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = _bloc.streamController.stream.listen(
      (event) {
        switch (event) {
          case Events.CANCEL:
            {
              injector<NavigationService>().goBack();
            }
            break;
          case Events.ON_NEXT_TO_DRIVER_INFO:
            {
              setState(() {
                _myAnimatedWidget = _driverInfo;
              });
            }
            break;
          case Events.ON_BACK_TO_CAR_INFO:
            {
              setState(() {
                _myAnimatedWidget = _carInfo;
              });
            }
            break;
          case Events.ON_NEXT_TO_ORDER_INFO:
            {
              setState(() {
                _myAnimatedWidget = _orderInfo;
              });
            }
            break;
          case Events.ON_BACK_TO_DRIVER_INFO:
            {
              setState(() {
                _myAnimatedWidget = _driverInfo;
              });
            }
            break;
          case Events.CREATE_ORDER:
            {
              showMessage("zaebis");
            }
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    _bloc.close();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget buildAppbar() {
    return null;
  }

  @override
  Widget buildBody() {
    if (_myAnimatedWidget == null) {
      _myAnimatedWidget = _carInfo;
    }
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener(
        bloc: _bloc,
        listener: blocListener,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getBack(),
              AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: _myAnimatedWidget),
            ],
          ),
        ),
      ),
    );
  }
}

class CarInfo extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CarInfoState();
  }
}

class CarInfoState extends BaseState<CarInfo> {
  CreateOrderBloc _bloc;
  var _carNumberController = TextEditingController();
  var _carModelController = TextEditingController();
  var _trailerNumberController = TextEditingController();
  List<DropdownMenuItem<Car>> _dropDownMenuItems;
  Car _selectedCar;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget getLayout() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Text(
              "Інформація про автомобіль",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorAccent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Text(
              "Виберіть автомобіль із списку або заповніть дані",
              maxLines: 2,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorAccent),
            ),
          ),
          StreamBuilder(
            stream: _bloc.getCars(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return getProgress(background: false);
              _dropDownMenuItems = snapshot.data.documents.map((document) {
                var cars = Car.fromJsonMap(document.data);
                return DropdownMenuItem(
                  value: cars,
                  child: Text(cars.carNumber),
                );
              }).toList();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 2.5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: colorAccent, width: 1)),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButton(
                          iconEnabledColor: colorAccent,
                          iconDisabledColor: colorAccent,
                          isExpanded: true,
                          value: _selectedCar,
                          hint: Text(
                            "Виберіть авто",
                            style: TextStyle(color: colorAccent),
                          ),
                          items: _dropDownMenuItems,
                          onChanged: (val) {
                            setState(() {
                              _selectedCar = val;
                              _carNumberController.text =
                                  _selectedCar.carNumber;
                              _carModelController.text = _selectedCar.carModel;
                              _trailerNumberController.text =
                                  _selectedCar.trailerNumber;
                            });
                          }),
                    ),
                  ),
                ),
              );
            },
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                side: BorderSide(width: 1, color: colorAccent)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Номер автомобіля",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.car.carNumber = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _carNumberController,
                    ),
                  ),
                  Text(
                    "Марка автомобіля",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.car.carModel = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _carModelController,
                    ),
                  ),
                  Text(
                    "Номер причіпу",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.car.trailerNumber = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _trailerNumberController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: BaseButton(
                    onClick: () {
                      _bloc.streamController.add(Events.CANCEL);
                    },
                    text: "Відмінити",
                    buttonColor: Colors.white,
                    borderColor: Colors.grey,
                    textColor: Colors.grey,
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 3,
                  child: BaseButton(
                    onClick: () {
                      _bloc.streamController.add(Events.ON_BACK_TO_DRIVER_INFO);
                    },
                    text: "Далі",
                    buttonColor: colorAccent,
                    borderColor: colorAccent,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DriverInfo extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DriverInfoState();
  }
}

class DriverInfoState extends BaseState<DriverInfo> {
  CreateOrderBloc _bloc;
  var _driverFirstNameController = TextEditingController();
  var _driverLastNameController = TextEditingController();
  var _driverEmailController = TextEditingController();
  var _driverPhoneController = TextEditingController();
  List<DropdownMenuItem<Driver>> _dropDownMenuItems;
  Driver _selectedDriver;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget getLayout() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Text(
              "Інформація про водія",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorAccent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Text(
              "Виберіть водія із списку або заповніть дані",
              maxLines: 2,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorAccent),
            ),
          ),
          StreamBuilder(
            stream: _bloc.getDrivers(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return getProgress(background: false);
              _dropDownMenuItems = snapshot.data.documents.map((document) {
                var drivers = Driver.fromJsonMap(document.data);
                return DropdownMenuItem(
                  value: drivers,
                  child: Text(drivers.getFullName()),
                );
              }).toList();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 2.5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: colorAccent, width: 1)),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButton(
                          isExpanded: true,
                          value: _selectedDriver,
                          hint: Text(
                            "Виберіть водія",
                            style: TextStyle(color: colorAccent),
                          ),
                          items: _dropDownMenuItems,
                          onChanged: (val) {
                            setState(() {
                              _selectedDriver = val;
                              _driverFirstNameController.text =
                                  _selectedDriver.firstName;
                              _driverLastNameController.text =
                                  _selectedDriver.lastName;
                              _driverPhoneController.text =
                                  _selectedDriver.phone;
                              _driverEmailController.text =
                                  _selectedDriver.email;
                            });
                          }),
                    ),
                  ),
                ),
              );
            },
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                side: BorderSide(width: 1, color: colorAccent)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Ім'я водія",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.driver.firstName = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _driverFirstNameController,
                    ),
                  ),
                  Text(
                    "Прізвище водія",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.driver.lastName = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _driverLastNameController,
                    ),
                  ),
                  Text(
                    "Номер телефону водія",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.driver.phone = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _driverPhoneController,
                    ),
                  ),
                  Text(
                    "Електронна пошта водія",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.driver.email = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _driverEmailController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: BaseButton(
                    onClick: () {
                      _bloc.streamController.add(Events.ON_BACK_TO_CAR_INFO);
                    },
                    text: "Назад",
                    buttonColor: Colors.white,
                    borderColor: Colors.grey,
                    textColor: Colors.grey,
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 3,
                  child: BaseButton(
                    onClick: () {
                      _bloc.streamController.add(Events.ON_NEXT_TO_ORDER_INFO);
                    },
                    text: "Далі",
                    buttonColor: colorAccent,
                    borderColor: colorAccent,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrderInfo extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrderInfoState();
  }
}

class OrderInfoState extends BaseState<OrderInfo> {
  var _orderOwnerController = TextEditingController();
  var _orderToController = TextEditingController();
  var _orderFromController = TextEditingController();
  CreateOrderBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget getLayout() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Інформація про замовлення",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: colorAccent),
          ),
          Text(
            "Заповніть дані",
            maxLines: 2,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: colorAccent),
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                side: BorderSide(width: 1, color: colorAccent)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Власник перевізника",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.owner = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _orderOwnerController,
                    ),
                  ),
                  Text(
                    "Пункт відвантаження",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.from = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _orderFromController,
                    ),
                  ),
                  Text(
                    "Пункт розвантаження",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      onChanged: ((String text) {
                        _bloc.order.to = text;
                      }),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: colorAccent, width: 1),
                        ),
                      ),
                      controller: _orderToController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: BaseButton(
                    onClick: () {
                      _bloc.streamController.add(Events.ON_BACK_TO_DRIVER_INFO);
                    },
                    text: "Назад",
                    buttonColor: Colors.white,
                    borderColor: Colors.grey,
                    textColor: Colors.grey,
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 3,
                  child: BaseButton(
                    onClick: () {
                      _bloc.streamController.add(Events.CREATE_ORDER);
                    },
                    text: "Створити",
                    buttonColor: colorAccent,
                    borderColor: colorAccent,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
