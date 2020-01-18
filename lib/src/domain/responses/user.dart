
class User {

  String firstName;
  String lastName;
  String photoUrl;
  String email;
  String phone;

	User.fromJsonMap(Map<String, dynamic> map): 
		firstName = map["firstName"],
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
