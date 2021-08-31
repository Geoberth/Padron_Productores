class CentroIntegradorModel {
  List<CentroIntegrador> centrosIntegradores;

  CentroIntegradorModel({this.centrosIntegradores});

  CentroIntegradorModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      centrosIntegradores = new List<CentroIntegrador>();
      json['data'].forEach((v) {
        centrosIntegradores.add(new CentroIntegrador.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.centrosIntegradores != null) {
      data['data'] = this.centrosIntegradores.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CentroIntegrador {
  String code;
  String name;
  String federal_entity_code;
  String municipality_code;
  CentroIntegrador({this.code, this.name,this.federal_entity_code,this.municipality_code});

  CentroIntegrador.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    federal_entity_code = json['federal_entity_code'];
    municipality_code = json['municipality_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['federal_entity_code'] = this.federal_entity_code;
    data['municipality_code'] = this.municipality_code;
    return data;
  }
}