import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/driver.dart';
import 'package:elevator/src/domain/responses/order/good.dart';
import 'package:elevator/src/domain/responses/order/stamp.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  String id;
  int type;
  int status;
  int timeStatus;
  List<Stamp> stamps;
  List<Good> goods;
  String owner;
  String from;
  String to;
  int createdAt;
  Driver driver;
  Car car;

  Order(
      {this.id,
      this.type,
      this.status,
      this.timeStatus,
      this.stamps,
      this.goods,
      this.owner,
      this.from,
      this.to,
      this.createdAt,
      this.driver,
      this.car}) {
//    car = Car("", "", "", "");
    goods = [];
    stamps = [];
  }

  Order.fromJsonMap(Map<dynamic, dynamic> map)
      : id = map["id"],
        type = map["type"],
        status = map["status"],
        timeStatus = map["timeStatus"],
        stamps =
            List<Stamp>.from(map["stamps"].map((it) => Stamp.fromJsonMap(it))),
        goods = List<Good>.from(map["goods"].map((it) => Good.fromJsonMap(it))),
        owner = map["owner"],
        from = map["from"],
        to = map["to"],
        driver = Driver.fromJsonMap(map["driver"]),
        car = Car.fromJsonMap(map["car"]),
        createdAt = map["createdAt"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
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
    data['createdAt'] = createdAt;
    data['driver'] = driver.toJson();
    data['car'] = car.toJson();
    return data;
  }

  @override
  List<Object> get props => [
        this.id,
        this.type,
        this.status,
        this.timeStatus,
        this.stamps,
        this.goods,
        this.owner,
        this.from,
        this.to,
        this.createdAt,
        this.driver,
        this.car
      ];
}
