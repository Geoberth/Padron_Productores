class MunicipiosModel {
  List<Municipio> municipios;

  MunicipiosModel({this.municipios});

  MunicipiosModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      municipios = new List<Municipio>();
      json['data'].forEach((v) {
        municipios.add(new Municipio.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.municipios != null) {
      data['data'] = this.municipios.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Municipio {
  String code;
  String name;
  String federal_entity_code;
  Municipio({this.code, this.name, this.federal_entity_code});

  Municipio.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    federal_entity_code= json['federal_entity_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['federal_entity_code'] = this.federal_entity_code;
    return data;
  }
}