import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/res/values/colors.dart';
import 'package:elevator/res/values/styles.dart';
import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/driver.dart';
import 'package:elevator/src/domain/responses/order/good.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/domain/responses/order/stamp.dart';
import 'package:elevator/src/view/create_order/create_order_bloc.dart';
import 'package:elevator/src/view/custom/BaseButton.dart';
import 'package:elevator/src/view/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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

  Widget _carInfo = CarInfo(
    key: UniqueKey(),
  );
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
              if (_bloc.isCarInfoValidate()) {
                setState(() {
                  _myAnimatedWidget = _driverInfo;
                });
              } else {
                showMessage("Заповніть всі поля");
              }
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
              if(_bloc.isDriverInfoValidate()){
                setState(() {
                  _myAnimatedWidget = _orderInfo;
                });
              }
            else{
              showMessage("Заповніть всі поля");
              }
//              setState(() {
//                _myAnimatedWidget = _orderInfo;
//              });
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
              if(_bloc.isOrderInfoValidate()){
                _bloc.createOrder();
                showMessage("zaebis");
              }
              else{
                showMessage("Заповніть всі поля");
              }

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
    return getAppBar(context, "Додавання вантажу", leading: getBack());
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
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _myAnimatedWidget)),
      ),
    );
  }
}

class CarInfo extends BaseStatefulWidget {
  CarInfo({Key key}) : super(key: key);

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

  bool get isEditable => !(_selectedCar == null || _selectedCar.id != "");

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                var car = Car.fromJsonMap(document.data);
                return DropdownMenuItem(
                  value: car,
                  child: Text(car.carNumber),
                );
              }).toList();
              _dropDownMenuItems.add(DropdownMenuItem(
                value: Car("", "", "", ""),
                child: Text("Інше"),
              ));
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
          Opacity(
            opacity: isEditable ? 1.0 : 0.5,
            child: Form(
              key: formKey,
              child: Card(
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
                        child: TextFormField(
                          key: UniqueKey(),
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.car.carNumber = text;
                          }),
                          decoration: InputDecoration(
                            hintText: "Введіть номер автомобіля",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
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
                        child: TextFormField(
                          key: UniqueKey(),
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.car.carModel = text;
                          }),
                          decoration: InputDecoration(
                            hintText: "Введіть марку автомобіля",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
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
                        child: TextFormField(
                          key: UniqueKey(),
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.car.trailerNumber = text;
                            print(_bloc.order.car.trailerNumber);
                          }),
                          decoration: InputDecoration(
                            hintText: "Введіть номер причіпу",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
                            ),
                          ),
                          controller: _trailerNumberController,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      _bloc.streamController.add(Events.ON_NEXT_TO_DRIVER_INFO);
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

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  bool get isEditable => !(_selectedDriver == null || _selectedDriver.id != "");

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
              _dropDownMenuItems.add(DropdownMenuItem(
                value: Driver("", "", "", "", "", ""),
                child: Text("Інше"),
              ));
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
          Opacity(
            opacity: isEditable ? 1.0 : 0.5,
            child: Form(
              key: formKey,
              child: Card(
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
                        child: TextFormField(
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.driver.firstName = text;
                          }),
                          decoration: InputDecoration(
                            hintText: "Введіть ім'я водія",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
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
                        child: TextFormField(
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.driver.lastName = text;
                          }),
                          decoration: InputDecoration(
                            hintText: "Введіть прізвище водія",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
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
                        child: TextFormField(
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.driver.phone = text;
                          }),
                          decoration: InputDecoration(
                            hintText: "Введіть номер телефону водія",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
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
                        child: TextFormField(
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.driver.email = text;
                          }),
                          decoration: InputDecoration(
                            hintText: "Введіть електронну пошту водія",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorAccent, width: 1),
                            ),
                          ),
                          controller: _driverEmailController,
                        ),
                      ),
                    ],
                  ),
                ),
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
  var _stampController = TextEditingController();
  var _cargoController = TextEditingController();
  var _weightController = TextEditingController();
  CreateOrderBloc _bloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  void _addStampHandler() {
    Stamp stamp = Stamp(Uuid().v1(), _stampController.text, false);
    _bloc.order.stamps.add(stamp);
    _stampController.clear();
    setState(() {});
  }

  void _addGoodHandler() {
    Good good = Good(
        Uuid().v1(), _cargoController.text, _weightController.text.toInt());
    _bloc.order.goods.add(good);
    _cargoController.clear();
    _weightController.clear();
    setState(() {});
  }

  @override
  Widget getLayout() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: formKey,
        child: Column(
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Інформація про замовлення",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorAccent),
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
                      "Вантаж",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorAccent),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _cargoController,
                        decoration: InputDecoration(
                          hintText: "Введіть вантаж",
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorAccent, width: 1),
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorAccent, width: 1),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Вага",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorAccent),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: false),
                              controller: _weightController,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: "Введіть вагу",
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: colorAccent, width: 1),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: colorAccent, width: 1),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.add), onPressed: _addGoodHandler)
                        ],
                      ),
                    ),
                    _buildGoodsItem(_bloc.order)
                  ],
                ),
              ),
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
                      "Пломби",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorAccent),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _stampController,
                              decoration: InputDecoration(
                                hintText: "Введіть номер пломби",
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: colorAccent, width: 1),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: colorAccent, width: 1),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.add),
                              onPressed: _addStampHandler)
                        ],
                      ),
                    ),
                    _buildStamps(context: context),
                  ],
                ),
              ),
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
                      child: TextFormField(
                        onChanged: ((String text) {
                          _bloc.order.owner = text;
                        }),
                        decoration: InputDecoration(
                          hintText: "Введіть власника перевізника",
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
                      child: TextFormField(
                        onChanged: ((String text) {
                          _bloc.order.from = text;
                        }),
                        decoration: InputDecoration(
                          hintText: "Введіть пункт відвантаження",
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
                      child: TextFormField(
                        onChanged: ((String text) {
                          _bloc.order.to = text;
                        }),
                        decoration: InputDecoration(
                          hintText: "Введіть пунки розвантаження",
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
                        _bloc.streamController
                            .add(Events.ON_BACK_TO_DRIVER_INFO);
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
      ),
    );
  }

  Widget _buildStamps({BuildContext context}) {
    return _bloc.order.stamps != null
        ? Wrap(
            children: _bloc.order.stamps
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2.5,
                      ),
                      child: Container(
                        child: Chip(
                          deleteIcon: CircleAvatar(
                            radius: 10,
                            child: FittedBox(
                                child: Icon(Icons.cancel), fit: BoxFit.contain),
                          ),
                          onDeleted: () {
                            setState(() {
                              _bloc.order.stamps.remove(item);
                            });
                          },
                          backgroundColor: colorAccent,
                          label: Text(
                            item.stampNumber,
                            style: getMidFontWhite(),
                          ),
                        ),
                      ),
                    ))
                .toList())
        : Offstage();
  }

  Widget _buildGoodsItem(Order order) {
    return _bloc.order.goods != null
        ? Wrap(
        children: _bloc.order.goods
            .map((item) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2.5,
          ),
          child: Container(
            child: Chip(
              deleteIcon: CircleAvatar(
                radius: 10,
                child: FittedBox(
                    child: Icon(Icons.cancel), fit: BoxFit.contain),
              ),
              onDeleted: () {
                setState(() {
                  _bloc.order.goods.remove(item);
                });
              },
              backgroundColor: colorAccent,
              label: Text(
                item.name+" "+item.count.toString()+" т",
                style: getMidFontWhite(),
              ),
            ),
          ),
        ))
            .toList())
        : Offstage();
  }
}
