import 'package:elevator/res/values/colors.dart';
import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/router/route_paths.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/models/order_status.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/view/main/home/tabs/custom_hero.dart';
import 'package:elevator/src/view/utils/image_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Order order;

  ListItem(this.order);

  @override
  Widget build(BuildContext context) {
    Color borderColor = colorAccent;
    if (order.status == OrderStatus.ACCEPTED.index)
      borderColor = Colors.greenAccent;
    else if (order.status == OrderStatus.DECLINED.index)
      borderColor = Colors.redAccent;
    bool isMobile() => (MediaQuery.of(context).size.shortestSide < 600.0);

    double textSizeBig = isMobile() ? 16 : 20;
    double textSizeSmall = isMobile() ? 14 : 18;

    return Padding(
      padding: isMobile()
          ? const EdgeInsets.all(8.0)
          : const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: RawMaterialButton(
        onPressed: () {
          injector<NavigationService>()
              .pushNamed(orderDetailRoute, arguments: order);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(color: borderColor, width: 1)),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile() ? 16.0 : 32.0),
                child: CustomHero(
                    isRotate: true,
                    tag: order.id,
                    child: getUserAvatar(
                        order.driver.photoUrl, isMobile() ? 50 : 80)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(color: colorAccent, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                order.car.carNumber,
                                style: TextStyle(
                                    color: colorAccent, fontSize: textSizeSmall),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                order.car.carModel,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: colorAccent, fontSize: textSizeBig),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: isMobile() ? 6 : 10),
                        child: Text(
                          order.goods[0].name +
                              " " +
                              order.goods[0].count.toString() +
                              "т",
                          style: TextStyle(
                              color: colorAccent, fontSize: textSizeSmall),
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
                                  fontSize: textSizeBig,
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
                                fontSize: textSizeBig,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
