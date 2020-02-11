import 'package:elevator/res/values/colors.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/view/custom/BaseButton.dart';
import 'package:elevator/src/view/main/home/tabs/custom_hero.dart';
import 'package:elevator/src/view/order_detail/order_details_bloc.dart';
import 'package:elevator/src/view/utils/date_utils.dart';
import 'package:elevator/src/view/utils/image_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetail extends BaseStatefulWidget {
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends BaseStatefulScreen<OrderDetail>
    with BaseBlocListener {
  OrderDetailsBloc _bloc = OrderDetailsBloc();

  @override
  Widget buildAppbar() {
    return getAppBar(context, "Деталі вантажу", leading: getBack());
  }

  @override
  Widget buildBody() {
    if (_bloc.order == null)
      _bloc.order = ModalRoute.of(context).settings.arguments;
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener(
        bloc: _bloc,
        listener: blocListener,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _bloc.isHistory
                    ? Text(
                        "Дата обробки: " +
                            getHistoryDate(_bloc.order.timeStatus).toString(),
                        style: TextStyle(fontSize: 21),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildButton("Відхилити", _askDecline),
                          _buildButton("Прийняти", _accept),
                        ],
                      ),
          CustomHero(
            tag: _bloc.order.id,
              isRotate: true,
              child: getUserAvatar(_bloc.order.driver.photoUrl, 50)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //getUserAvatar(order.driver.photoUrl, 50),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: colorAccent, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            _bloc.order.car.carNumber,
                            style: TextStyle(color: colorAccent, fontSize: 14),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _bloc.order.car.carModel,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: colorAccent, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        _bloc.order.driver.getFullName(),
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: colorAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      _bloc.order.driver.phone,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: colorAccent,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Номер причіпу ",
                        style: TextStyle(color: colorAccent),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: colorAccent, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            _bloc.order.car.trailerNumber,
                            style: TextStyle(color: colorAccent, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Список пломб',
                    style: TextStyle(color: colorAccent),
                  ),
                ),
                _buildStampsItem(_bloc.order),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Вантаж',
                    style: TextStyle(color: colorAccent),
                  ),
                ),
                _buildGoodsItem(_bloc.order),
                _builditem("Власник перевізника", _bloc.order.owner),
                _builditem("Пункт відвантаження", _bloc.order.from),
                _builditem("Пункт розвантаження", _bloc.order.to),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildStampsItem(Order order) {
    List<Widget> children = [];
    for (int i = 0; i < order.stamps.length; ++i) {
      children.add(Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 2.5,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    order.stamps[i].stampNumber,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: colorAccent),
                  ),
                ),
                CupertinoSwitch(
                  onChanged: _bloc.isHistory
                      ? null
                      : (value) {
                          _bloc.stamps[i] = value;
                          setState(() {});
                        },
                  value: _bloc.stamps[i],
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return Column(children: children);
  }

  Column _buildGoodsItem(Order order) {
    return Column(
        children: order.goods
            .map((o) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(color: colorAccent, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              o.name,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: TextStyle(color: colorAccent),
                            ),
                          ),
                          Text(
                            o.count.toString() + " т",
                            style: TextStyle(color: colorAccent),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
            .toList());
  }

  Column _builditem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: TextStyle(color: colorAccent, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: colorAccent, width: 1)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                description,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(color: colorAccent, fontSize: 17),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String buttonName, Function onClick) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
        child: BaseButton(
          text: buttonName,
          onClick: onClick,
        ),
      ),
    );
  }

  void _askDecline() {
    showAlert(
        context, "Відхилення", "Ви впевнеі, що бажаєте віхилити?", _decline);
  }

  void _accept() {
    _bloc.accept();
  }

  void _decline() {
    _bloc.decline();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
