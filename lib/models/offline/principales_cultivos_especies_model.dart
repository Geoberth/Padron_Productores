class PrincipalesCultivosEspeciesModel {
  List<PrincipalCultivoEspecie> principalesCultivosEspecies;

  PrincipalesCultivosEspeciesModel({this.principalesCultivosEspecies});

  PrincipalesCultivosEspeciesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      principalesCultivosEspecies = new List<PrincipalCultivoEspecie>();
      json['data'].forEach((v) {
        principalesCultivosEspecies.add(new PrincipalCultivoEspecie.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.principalesCultivosEspecies != null) {
      data['data'] = this.principalesCultivosEspecies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrincipalCultivoEspecie {
  String code;
  String name;
  int food_industry_code;
  PrincipalCultivoEspecie({this.code, this.name,this.food_industry_code});

  PrincipalCultivoEspecie.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    food_industry_code = json['food_industry_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['food_industry_code'] = food_industry_code;
    return data;
  }
}