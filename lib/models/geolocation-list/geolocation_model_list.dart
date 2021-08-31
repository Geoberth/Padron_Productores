
class GeolocationsModel {
  int code;
  String msg;
  List<Parcela> parcelas;

  GeolocationsModel({this.code,this.msg,this.parcelas});

  GeolocationsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      parcelas = new List<Parcela>();
      json['data'].forEach((v) {
        parcelas.add(new Parcela.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['code'] = this.code;
      data['msg'] = this.msg;
    if (this.parcelas != null) {
      data['data'] = this.parcelas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parcela {
  String idUnico;
  //String item;
  String categoryId;
  String plotsId;
  int ogcFid;

  Parcela({this.idUnico, this.categoryId, this.plotsId});

  Parcela.fromJson(Map<String, dynamic> json) {
    idUnico = json['id_unico'];
   // item = json['item'];
    categoryId = json['category_id'];
    plotsId = json['food_industry'];
    ogcFid = json['ogc_fid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_unico'] = this.idUnico;
    //data['item'] = this.item;
    data['category_id'] = this.categoryId;
    data['food_industry'] = this.plotsId;
    data['ogc_fid'] = this.ogcFid;
    return data;
  }
}