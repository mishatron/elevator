class Driver {
  String firstName;
  String lastName;
  String photoUrl;
  String email;
  String phone;

  Driver(this.firstName, this.lastName, this.phone, this.email, this.photoUrl);

  Driver.fromJsonMap(Map<dynamic, dynamic> map)
      : firstName = map["firstName"],
        lastName = map["lastName"],
        photoUrl = map["photoUrl"],
        email = map["email"],
        phone = map["phone"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['photoUrl'] = photoUrl;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
