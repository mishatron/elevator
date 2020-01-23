class Car {
  String carModel;
  String carNumber;
  String trailerNumber;

  Car(this.carModel, this.carNumber, this.trailerNumber);

  Car.fromJsonMap(Map<String, dynamic> map)
      : carModel = map["carModel"],
        carNumber = map["carNumber"],
        trailerNumber = map["trailerNumber"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carModel'] = carModel;
    data['carNumber'] = carNumber;
    data['trailerNumber'] = trailerNumber;
    return data;
  }
}
