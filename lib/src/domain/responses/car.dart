import 'package:equatable/equatable.dart';

class Car extends Equatable {
  String id;
  String carModel;
  String carNumber;
  String trailerNumber;

  Car(this.id, this.carModel, this.carNumber, this.trailerNumber);

  Car.fromJsonMap(Map<dynamic, dynamic> map)
      : carModel = map["carModel"],
        carNumber = map["carNumber"],
        id = map["id"],
        trailerNumber = map["trailerNumber"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['carModel'] = carModel;
    data['carNumber'] = carNumber;
    data['trailerNumber'] = trailerNumber;
    return data;
  }

  @override
  List<Object> get props => [id, carModel, carNumber, trailerNumber];
}
