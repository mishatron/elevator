import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/res/values/colors.dart';
import 'package:elevator/res/values/styles.dart';
import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/bundle.dart';
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
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
                showMessage("Заповніть всі поля вірно");
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
              if (_bloc.isDriverInfoValidate()) {
                setState(() {
                  _myAnimatedWidget = _orderInfo;
                });
              } else {
                showMessage("Заповніть всі поля вірно");
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
              if (_bloc.isOrderInfoValidate() &&
                  _bloc.isCreateOrderValidate()) {
                _bloc.createOrder();
              } else {
                showMessage("Заповніть всі поля вірно");
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
    int type =
        (ModalRoute.of(context).settings.arguments as Bundle).getInt("tab");
    _bloc.order.type = type;
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

  var _carNumberFocusNode = FocusNode();
  var _carModelFocusNode = FocusNode();
  var _trailerNumberFocusNode = FocusNode();
  List<DropdownMenuItem<Car>> _dropDownMenuItems;

  bool get isEditable => !(_bloc.order.car == null || _bloc.order.car.id != "");

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);

    if (_bloc.order.car != null) {
      _carModelController.text = _bloc.order.car.carModel;
      _carNumberController.text = _bloc.order.car.carNumber;
      _trailerNumberController.text = _bloc.order.car.trailerNumber;
    }
  }

  @override
  Widget getLayout() {
    double textSize = isMobile() ? 16 : 20;
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
                  fontSize: isMobile() ? 20 : 26,
                  fontWeight: FontWeight.bold,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Text(
              "Виберіть автомобіль із списку або заповніть дані",
              maxLines: 2,
              style: TextStyle(
                  fontSize: isMobile() ? 16 : 20,
                  fontWeight: FontWeight.bold,),
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
                      border: Border.all(color: colorBorder, width: 1)),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButton(
                          iconEnabledColor: colorBorder,
                          iconDisabledColor: colorBorder,
                          isExpanded: true,
                          value: _bloc.order.car == null
                              ? null
                              : _bloc.order.car.id == ""
                                  ? Car("", "", "", "")
                                  : _bloc.order.car,
                          hint: Text(
                            "Виберіть авто",
                            style: TextStyle(
                                color: colorBorder, fontSize: textSize),
                          ),
                          items: _dropDownMenuItems,
                          onChanged: (val) {
                            setState(() {
                              _bloc.order.car = val;
                              _carNumberController.text =
                                  _bloc.order.car.carNumber;
                              _carModelController.text =
                                  _bloc.order.car.carModel;
                              _trailerNumberController.text =
                                  _bloc.order.car.trailerNumber;
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
                color: colorPrimaryDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(width: 1, color: colorBorder)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Номер автомобіля",
                        style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          key: UniqueKey(),
                          focusNode: _carNumberFocusNode,
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.car.carNumber = text;
                          }),
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _carNumberFocusNode.unfocus();
                            _carModelFocusNode.requestFocus();
                          },
                          inputFormatters: [
                            MaskTextInputFormatter(mask: '== #### ==', filter: {
                              "=": RegExp(r'[А-Я]'),
                              "#": RegExp(r'[0-9]')
                            })
                          ],
                          decoration: InputDecoration(
                            hintText: "Введіть номер автомобіля",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                          ),
                          controller: _carNumberController,
                        ),
                      ),
                      Text(
                        "Марка автомобіля",
                        style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          focusNode: _carModelFocusNode,
                          key: UniqueKey(),
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.car.carModel = text;
                          }),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _carModelFocusNode.unfocus();
                            _trailerNumberFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            hintText: "Введіть марку автомобіля",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                          ),
                          controller: _carModelController,
                        ),
                      ),
                      Text(
                        "Номер причіпу",
                        style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          focusNode: _trailerNumberFocusNode,
                          key: UniqueKey(),
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            MaskTextInputFormatter(mask: '== #### ==', filter: {
                              "=": RegExp(r'[А-Я]'),
                              "#": RegExp(r'[0-9]')
                            })
                          ],
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.car.trailerNumber = text;
                            print(_bloc.order.car.trailerNumber);
                          }),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _trailerNumberFocusNode.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: "Введіть номер причіпу",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
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
  var _firstNameFocusNode = FocusNode();
  var _lastNameFocusNode = FocusNode();
  var _phoneFocusNode = FocusNode();
  var _emailFocusNode = FocusNode();
  List<DropdownMenuItem<Driver>> _dropDownMenuItems;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    if (_bloc.order.driver != null) {
      _driverFirstNameController.text = _bloc.order.driver.firstName;
      _driverLastNameController.text = _bloc.order.driver.lastName;
      _driverPhoneController.text = _bloc.order.driver.phone;
      _driverEmailController.text = _bloc.order.driver.email;
    }
  }

  bool get isEditable =>
      !(_bloc.order.driver == null || _bloc.order.driver.id != "");

  @override
  Widget getLayout() {
    double textSize = isMobile() ? 16 : 20;
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
                  fontSize: isMobile() ? 20 : 24,
                  fontWeight: FontWeight.bold,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Text(
              "Виберіть водія із списку або заповніть дані",
              maxLines: 2,
              style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,),
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
                      border: Border.all(color: colorBorder, width: 1)),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButton(
                          isExpanded: true,
                          value: _bloc.order.driver,
                          hint: Text(
                            "Виберіть водія",
                            style: TextStyle(color: colorBorder),
                          ),
                          items: _dropDownMenuItems,
                          onChanged: (val) {
                            setState(() {
                              _bloc.order.driver = val;
                              _driverFirstNameController.text =
                                  _bloc.order.driver.firstName;
                              _driverLastNameController.text =
                                  _bloc.order.driver.lastName;
                              _driverPhoneController.text =
                                  _bloc.order.driver.phone;
                              _driverEmailController.text =
                                  _bloc.order.driver.email;
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
                color: colorPrimaryDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(width: 1, color: colorBorder)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Ім'я водія",
                        style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          readOnly: !isEditable,
                          focusNode: _firstNameFocusNode,
                          onChanged: ((String text) {
                            _bloc.order.driver.firstName = text;
                          }),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _firstNameFocusNode.unfocus();
                            _lastNameFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            hintText: "Введіть ім'я водія",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                          ),
                          controller: _driverFirstNameController,
                        ),
                      ),
                      Text(
                        "Прізвище водія",
                        style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          readOnly: !isEditable,
                          focusNode: _lastNameFocusNode,
                          onChanged: ((String text) {
                            _bloc.order.driver.lastName = text;
                          }),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _lastNameFocusNode.unfocus();
                            _phoneFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            hintText: "Введіть прізвище водія",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                          ),
                          controller: _driverLastNameController,
                        ),
                      ),
                      Text(
                        "Номер телефону водія",
                        style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          focusNode: _phoneFocusNode,
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.driver.phone = text;
                          }),
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: '+ 38 (###) ### ## ##',
                                filter: {"#": RegExp(r'[0-9]')})
                          ],
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _phoneFocusNode.unfocus();
                            _emailFocusNode.requestFocus();
                          },
                          decoration: InputDecoration(
                            hintText: "Введіть номер телефону водія",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                          ),
                          controller: _driverPhoneController,
                        ),
                      ),
                      Text(
                        "Електронна пошта водія",
                        style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          focusNode: _emailFocusNode,
                          readOnly: !isEditable,
                          onChanged: ((String text) {
                            _bloc.order.driver.email = text;
                          }),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _emailFocusNode.unfocus();
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Введіть електронну пошту водія",
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: colorBorder, width: 1),
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
  var _cargoFocusNode = FocusNode();
  var _weightFocusNode = FocusNode();
  var _stampsFocusNode = FocusNode();
  var _ownerFocusNode = FocusNode();
  var _fromFocusNode = FocusNode();
  var _toFocusNode = FocusNode();
  CreateOrderBloc _bloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _orderOwnerController.text = _bloc.order.owner;
    _orderFromController.text = _bloc.order.from;
    _orderToController.text = _bloc.order.to;
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
    double textSize = isMobile() ? 16 : 20;
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
                  fontSize: isMobile() ? 20 : 24,
                  fontWeight: FontWeight.bold,),
            ),
            Card(
              color: colorPrimaryDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(width: 1, color: colorBorder)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Вантаж",
                      style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _cargoController,
                        focusNode: _cargoFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _cargoFocusNode.unfocus();
                          _weightFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Введіть вантаж",
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorBorder, width: 1),
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorBorder, width: 1),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Вага",
                      style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              focusNode: _weightFocusNode,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: false),
                              controller: _weightController,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                _weightFocusNode.unfocus();
                              },
                              decoration: InputDecoration(
                                hintText: "Введіть вагу",
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: colorBorder, width: 1),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: colorBorder, width: 1),
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
              color: colorPrimaryDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(width: 1, color: colorBorder)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Пломби",
                      style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              focusNode: _stampsFocusNode,
                              controller: _stampController,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                _stampsFocusNode.unfocus();
                              },
                              decoration: InputDecoration(
                                hintText: "Введіть номер пломби",
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: colorBorder, width: 1),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: colorBorder, width: 1),
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
              color: colorPrimaryDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(width: 1, color: colorBorder)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Власник перевізника",
                      style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        focusNode: _ownerFocusNode,
                        onChanged: ((String text) {
                          _bloc.order.owner = text;
                        }),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _ownerFocusNode.unfocus();
                          _fromFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Введіть власника перевізника",
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorBorder, width: 1),
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorBorder, width: 1),
                          ),
                        ),
                        controller: _orderOwnerController,
                      ),
                    ),
                    Text(
                      "Пункт відвантаження",
                      style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        focusNode: _fromFocusNode,
                        onChanged: ((String text) {
                          _bloc.order.from = text;
                        }),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _fromFocusNode.unfocus();
                          _toFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Введіть пункт відвантаження",
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorBorder, width: 1),
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorBorder, width: 1),
                          ),
                        ),
                        controller: _orderFromController,
                      ),
                    ),
                    Text(
                      "Пункт розвантаження",
                      style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        focusNode: _toFocusNode,
                        onChanged: ((String text) {
                          _bloc.order.to = text;
                        }),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _toFocusNode.unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Введіть пунки розвантаження",
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorBorder, width: 1),
                          ),
                          border: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: colorBorder, width: 1),
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
                            item.name + " " + item.count.toString() + " т",
                            style: getMidFontWhite(),
                          ),
                        ),
                      ),
                    ))
                .toList())
        : Offstage();
  }
}
