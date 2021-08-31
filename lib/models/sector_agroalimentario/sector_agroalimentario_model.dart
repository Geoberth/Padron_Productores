class SectorAgroalimentarioModel {
  List<SectorAgroalimentario> sectoresAgroalimentarios;

  SectorAgroalimentarioModel({this.sectoresAgroalimentarios});

  SectorAgroalimentarioModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      sectoresAgroalimentarios = new List<SectorAgroalimentario>();
      json['data'].forEach((v) {
        sectoresAgroalimentarios.add(new SectorAgroalimentario.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sectoresAgroalimentarios != null) {
      data['data'] = this.sectoresAgroalimentarios.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SectorAgroalimentario {
  int code;
  String name;
  int filesRequired;
  List<Validation> validation;

  SectorAgroalimentario({this.code, this.name, this.validation,this.filesRequired});

  SectorAgroalimentario.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    filesRequired = json['files_required'];
    if (json['validation'] != null) {
      validation = new List<Validation>();
      json['validation'].forEach((v) {
        validation.add(new Validation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['files_required'] = this.filesRequired;
    if (this.validation != null) {
      data['validation'] = this.validation.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Validation {
  int id;
  int type;
  String label;
  bool show;

  Validation({this.id, this.type, this.label, this.show});

  Validation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    label = json['label'];
    show = json['show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['label'] = this.label;
    data['show'] = this.show;
    return data;
  }
}