
class Good {

  String name;
  int count;

  Good(this.name, this.count);

	Good.fromJsonMap(Map<dynamic, dynamic> map):
		name = map["name"],
		count = map["count"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = name;
		data['count'] = count;
		return data;
	}
}
