class Stamp {
  String stampNumber;
  bool stampStatus;

  Stamp(this.stampNumber, this.stampStatus);

  Stamp.fromJsonMap(Map<dynamic, dynamic> map)
      : stampNumber = map["stampNumber"],
        stampStatus = map["stampStatus"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stampNumber'] = stampNumber;
    data['stampStatus'] = stampStatus;
    return data;
  }
}
