import 'package:elevator/res/values/colors.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/view/custom/BaseButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetail extends BaseStatefulWidget {
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends BaseStatefulScreen<OrderDetail> {
  Order order;

  @override
  Widget buildAppbar() {
    return getAppBar(context, "Деталі вантажу", leading: getBack());
  }

  @override
  Widget buildBody() {
    if (order == null) order = ModalRoute.of(context).settings.arguments;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildButton("Відхилити", _askDecline),
                _buildButton("Прийняти", _accept),
              ],
            ),
            Row(
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
                      order.car.carNumber,
                      style: TextStyle(color: colorAccent, fontSize: 14),
                    ),
                  ),
                ),
                Text(
                  order.car.carModel,
                  style: TextStyle(color: colorAccent, fontSize: 16),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                order.goods[0].name + " " + order.goods[0].count.toString() + "т",
                style: TextStyle(color: colorAccent, fontSize: 14),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    order.driver.getFullName(),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: colorAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    order.driver.phone,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: colorAccent,
                      fontSize: 16,
                    ),
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
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(color: colorAccent, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        order.car.trailerNumber,
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
            _buildStampsItem(order),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Вантаж',
                style: TextStyle(color: colorAccent),
              ),
            ),
            _buildGoodsItem(order),
            _builditem("Власник перевізника", order.owner),
            _builditem("Пункт відвантаження", order.from),
            _builditem("Пункт розвантаження", order.to),
          ],
        ),
      ),
    );
  }

  Column _buildStampsItem(Order order) {
    return Column(
        children: order.stamps
            .map((stamp) => Padding(
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
                          Text(
                            stamp.stampNumber,
                            style: TextStyle(color: colorAccent),
                          ),
                          CupertinoSwitch(
                            onChanged: (value) {},
                            value: stamp.stampStatus,
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList());
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
                          Text(
                            o.name,
                            style: TextStyle(color: colorAccent),
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

  void _askDecline(){
    showAlert(context, "Відхилення", "Ви впевнеі, що бажаєте віхилити?", _decline);
  }
  void _accept(){
    showMessage("Типу прийнто");
  }
  void _decline(){
    showMessage("Типу відхилено");
  }

}
