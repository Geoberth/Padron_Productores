import 'dart:io';

class PdfModel {
  String base64;
  String name;
  File fl;

  PdfModel({this.base64, this.name, this.fl});

  PdfModel.fromJson(Map<String, dynamic> json) {
    base64 = json['base64'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base64'] = this.base64;
    data['name'] = this.name;
    return data;
  }
}