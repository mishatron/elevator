import 'package:elevator/src/domain/responses/order/order.dart';

class History {
  String id;
  Order order;
  String guardId;

  History.fromJsonMap(Map<dynamic, dynamic> map)
      : order = map["order"] != null ? Order.fromJsonMap(map["order"]) : null,
        guardId = map["guardId"],
        id = map["id"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = order != null ? order.toJson() : null;
    data['guardId'] = guardId;
    data['id'] = id;
    return data;
  }
}
