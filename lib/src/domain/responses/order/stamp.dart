import 'package:equatable/equatable.dart';

class Stamp extends Equatable {
  String id;
  String stampNumber;
  bool stampStatus;

  Stamp(this.id, this.stampNumber, this.stampStatus);

  Stamp.fromJsonMap(Map<dynamic, dynamic> map)
      : stampNumber = map["stampNumber"],
        stampStatus = map["stampStatus"],
        id = map["id"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['stampNumber'] = stampNumber;
    data['stampStatus'] = stampStatus;
    return data;
  }

  @override
  List<Object> get props => [id, stampStatus, stampNumber];
}
