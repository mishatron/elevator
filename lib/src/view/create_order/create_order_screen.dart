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
import 'package:elevator/src/view/create_order/create_order_bloc.dart';
import 'package:elevator/src/view/custom/BaseButton.dart';
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
  var _poolNameController = TextEditingController();
  var _poolLocationController = TextEditingController();
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
          Text(
            "Інформація про автомобіль",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: colorAccent),
          ),
          Text(
            "Виберіть автомобіль із списку або заповніть дані",
            maxLines: 2,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: colorAccent),
          ),
          StreamBuilder(
            stream: _bloc.getCars(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return getProgress(background: false);
              _dropDownMenuItems = snapshot.data.documents.map((document) {
                var cars =  Car.fromJsonMap(document.data);
                return DropdownMenuItem(
                  value: cars,
                  child: Text(cars.carNumber),
                );
              }).toList();
              return DropdownButton(
                  isExpanded: true,
                  value: _selectedCar ,
                  hint: Text("Виберіть авто"),
                  items: _dropDownMenuItems,
                  onChanged: (val){
                    setState(() {
                      _selectedCar = val;
                    });
                  }
              );
            },
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
  var _descriptionController = TextEditingController();
  var _interestsController = TextEditingController();

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
            "Інформація про водія",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: colorAccent),
          ),
          Text(
            "Виберіть водія із списку або заповніть дані",
            maxLines: 2,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: colorAccent),
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
  var _ethereumController = TextEditingController();
  var _entranceFeeController = TextEditingController();
  var _matchController = TextEditingController();
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
