import 'package:elevator/res/values/colors.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/view/utils/image_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Order order;

  ListItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: colorAccent, width: 1)),
        child: ListTile(
          onTap: () {},
          leading: getUserAvatar(order.driver.photoUrl, 50),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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
                  order.goods[0].name +
                      " " +
                      order.goods[0].count.toString() +
                      "т",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
