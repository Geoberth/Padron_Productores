class LocalidadesModel {
  List<Localidad> localidades;

  LocalidadesModel({this.localidades});

  LocalidadesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      localidades = new List<Localidad>();
      json['data'].forEach((v) {
          localidades.add(new Localidad.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.localidades != null) {
      data['data'] = this.localidades.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Localidad {
  String code;
  String name;
  String federal_entity_code;
  String municipality_code;
  Localidad({this.code, this.name, this.federal_entity_code, this.municipality_code});

  Localidad.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    federal_entity_code= json['federal_entity_code'];
    municipality_code = json['municipality_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['federal_entity_code'] = this.federal_entity_code;
    data['municipality_code']=this.municipality_code;
    return data;
  }
}