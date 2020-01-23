import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/driver.dart';
import 'package:elevator/src/domain/responses/order/good.dart';
import 'package:elevator/src/domain/responses/order/stamp.dart';

class Order {
  int type;
  int status;
  int timeStatus;
  List<Stamp> stamps;
  List<Good> goods;
  String owner;
  String from;
  String to;
  String driverId;
  String carId;
  int createdAt;
  Driver driver;
  Car car;

  Order(
    this.type,
    this.status,
    this.timeStatus,
    this.stamps,
    this.goods,
    this.owner,
    this.from,
    this.to,
    this.driverId,
    this.carId,
    this.createdAt,
    /*this.driver,
      this.car*/
  );

  Order.fromJsonMap(Map<dynamic, dynamic> map)
      : type = map["type"],
        status = map["status"],
        timeStatus = map["timeStatus"],
        stamps =
            List<Stamp>.from(map["stamps"].map((it) => Stamp.fromJsonMap(it))),
        goods = List<Good>.from(map["goods"].map((it) => Good.fromJsonMap(it))),
        owner = map["owner"],
        from = map["from"],
        to = map["to"],
        driverId = map["driverId"],
        carId = map["carId"],
        driver = map["driver"],
        car = map["car"],
        createdAt = map["createdAt"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = type;
    data['status'] = status;
    data['timeStatus'] = timeStatus;
    data['stamps'] =
        stamps != null ? this.stamps.map((v) => v.toJson()).toList() : null;
    data['goods'] =
        goods != null ? this.goods.map((v) => v.toJson()).toList() : null;
    data['owner'] = owner;
    data['from'] = from;
    data['to'] = to;
    data['driverId'] = driverId;
    data['carId'] = carId;
    data['createdAt'] = createdAt;
    data['driver'] = driver;
    data['car'] = car;
    return data;
  }
}