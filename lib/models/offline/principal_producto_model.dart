class PrincipalProductoModel {
  List<PrincipalProducto> principalproductos;

  PrincipalProductoModel({this.principalproductos});

  PrincipalProductoModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      principalproductos = new List<PrincipalProducto>();
      json['data'].forEach((v) {
        principalproductos.add(new PrincipalProducto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.principalproductos != null) {
      data['data'] = this.principalproductos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrincipalProducto {
  String code;
  String name;
  String cat_crops_code;
  int food_industry_id;
  PrincipalProducto({this.code, this.name, this.cat_crops_code,this.food_industry_id });

  PrincipalProducto.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    cat_crops_code= json['cat_crops_code'];
    food_industry_id = json['food_industry_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['cat_crops_code'] = this.cat_crops_code;
    data['food_industry_id'] = this.food_industry_id;
    return data;
  }
}