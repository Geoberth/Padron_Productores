import 'package:siap/models/sector_agroalimentario/sector_agroalimentario_model.dart';

class ParcelasModel {
  List<Parcela> parcelas;

  ParcelasModel({this.parcelas});

  ParcelasModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      parcelas = new List<Parcela>();
      json['data'].forEach((v) {
        parcelas.add(new Parcela.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parcelas != null) {
      data['data'] = this.parcelas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parcela {
  int id;
  String item;
  int categoryId;
  int plotsId;
  SectorAgroalimentario foodIndustry;

  Parcela({this.id, this.item, this.categoryId, this.plotsId});

  Parcela.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    item = json['item'];
    categoryId = json['category_id'];
    plotsId = json['plots_id'];
    foodIndustry = json['food_industry'] != null
        ? new SectorAgroalimentario.fromJson(json['food_industry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item'] = this.item;
    data['category_id'] = this.categoryId;
    data['plots_id'] = this.plotsId;
    if (this.foodIndustry != null) {
      data['food_industry'] = this.foodIndustry.toJson();
    }
    return data;
  }
}