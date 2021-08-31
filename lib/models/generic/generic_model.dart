class GenericModel<T> {
  List<GenericData> items;

  GenericModel({this.items});

  GenericModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      items = new List<GenericData<T>>();
      json['data'].forEach((v) {
        items.add(new GenericData<T>.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['data'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GenericData<T> {
  T code;
  String name;

  GenericData({this.code, this.name});

  GenericData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}