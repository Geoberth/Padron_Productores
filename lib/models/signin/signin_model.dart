class SignInModel {
  int code;
  String msg;
  UserMobile data;

  SignInModel({this.code, this.msg, this.data});

  SignInModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new UserMobile.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class UserMobile {
  int tipoPersona;
  String curp;
  String rfc;
  String email;
  String phone;

  UserMobile({this.tipoPersona, this.curp, this.rfc, this.email, this.phone});

  UserMobile.fromJson(Map<String, dynamic> json) {
    tipoPersona = json['tipoPersona'];
    curp = json['curp'];
    rfc = json['rfc'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tipoPersona'] = this.tipoPersona;
    data['curp'] = this.curp;
    data['rfc'] = this.rfc;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}