import 'package:equatable/equatable.dart';

class Good extends Equatable {
  String id;
  String name;
  int count;

  Good(this.id, this.name, this.count);

  Good.fromJsonMap(Map<dynamic, dynamic> map)
      : id = map["id"],
        name = map["name"],
        count = map["count"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['count'] = count;
    return data;
  }

  @override
  List<Object> get props => [id, name, count];
}
