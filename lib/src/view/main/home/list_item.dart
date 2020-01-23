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
          onTap: (){},
          leading: getUserAvatar("sdfsdf", 50),
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
                        "sdfsdf",
                        style: TextStyle(color: colorAccent, fontSize: 14),
                      ),
                    ),
                  ),
                  Text(
                    "sdfsdf",
                    style: TextStyle(color: colorAccent, fontSize: 16),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "sdfsdf",
                  style: TextStyle(color: colorAccent, fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "dfsdf",
                    style: TextStyle(
                        color: colorAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "fdsdfs",
                    style: TextStyle(
                      color: colorAccent,
                      fontSize: 16,
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
