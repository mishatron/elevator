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
    Color borderColor = Colors.transparent;
    if (order.status == OrderStatus.ACCEPTED.index)
      borderColor = colorAccent;
    else if (order.status == OrderStatus.DECLINED.index)
      borderColor = Colors.redAccent;
    bool isMobile() => (MediaQuery.of(context).size.shortestSide < 600.0);

    double textSizeBig = isMobile() ? 16 : 20;
    double textSizeSmall = isMobile() ? 14 : 18;

    return Padding(
      padding: isMobile()
          ? const EdgeInsets.symmetric(horizontal: 8.0)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: RawMaterialButton(
        onPressed: () {
          injector<NavigationService>()
              .pushNamed(orderDetailRoute, arguments: order);
        },
        child: Card(
          elevation: 6.0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isMobile() ? 8.0 : 32.0),
                  child: CustomHero(
                      isScale: true,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          border: Border.all(
                                              color: colorBorder, width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          order.car.carNumber,
                                          style: TextStyle(
                                              fontSize: textSizeSmall),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          order.car.carModel,
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          style:
                                              TextStyle(fontSize: textSizeBig),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              (order.status == OrderStatus.ACCEPTED.index ||
                                      order.status ==
                                          OrderStatus.DECLINED.index)
                                  ? Container(
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.only(left: 8.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: borderColor,
                                      ),
                                    )
                                  : const Offstage(),
                            ]),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: isMobile() ? 6 : 10),
                          child: Text(
                            order.goods[0].name +
                                " " +
                                order.goods[0].count.toString() +
                                "т",
                            style: TextStyle(fontSize: textSizeSmall),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                order.driver.getFullName(),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    fontSize: textSizeBig,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              order.driver.phone,
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: textSizeBig,
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
      ),
    );
  }
}
