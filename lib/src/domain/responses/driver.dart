import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  String id;
  String firstName;
  String lastName;
  String photoUrl;
  String email;
  String phone;

  Driver(this.id, this.firstName, this.lastName, this.phone, this.email,
      this.photoUrl);

  Driver.fromJsonMap(Map<dynamic, dynamic> map)
      : id = map["id"],
        firstName = map["firstName"],
        lastName = map["lastName"],
        photoUrl = map["photoUrl"],
        email = map["email"],
        phone = map["phone"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['photoUrl'] = photoUrl;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }

  String getFullName() {
    return firstName + " " + lastName;
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, phone, email, photoUrl, lastName, firstName];
}
