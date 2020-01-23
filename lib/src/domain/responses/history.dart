import 'package:elevator/src/domain/responses/order/order.dart';

class History {
  Order order;
  String guardId;

  History.fromJsonMap(Map<dynamic, dynamic> map)
      : order = map["order"] != null ? Order.fromJsonMap(map["order"]) : null,
        guardId = map["guardId"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = order != null ? order.toJson() : null;
    data['guardId'] = guardId;
    return data;
  }
}
