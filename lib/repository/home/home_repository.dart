import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:siap/models/geolocation-list/geolocation_model_list.dart';
import 'package:siap/utils/api/api_base_helper.dart';
import 'package:siap/utils/settings.dart';

class HomeRepository {
  ApiBaseHelper _apiHelper;

  String _urlArchivos;
  String _urlValidacion;
  String _urlParcelasFisico;
  String _urlParcelasMoral;
  String _urlAddParcela;
  String _urlDeleteParcela;
  String _urlMapWebView;
String _urlDeleteParcelaMoral;
  HomeRepository(){
    _urlArchivos = "${Settings.apiSegment}/users/file/store";
    _urlValidacion = "${Settings.apiSegment}/users/check/validate/status";
    //_urlParcelas = "${Settings.apiSegment}/users/plot-geo/list";
    _urlParcelasFisico = "${Settings.apiSegment}/users/curp";
    _urlParcelasMoral = "${Settings.apiSegment}/users/rfc";
    _urlAddParcela = "${Settings.apiSegment}/users/plot-geo/store";
    _urlDeleteParcela = "${Settings.apiSegment}/users/plot-geo/destroy";
    _urlDeleteParcelaMoral = "${Settings.apiSegment}/users/plot-geo-moral/destroy";
    _urlMapWebView = "${Settings.apiSegment}/users/map";
    _apiHelper = ApiBaseHelper();
  }

  Future<Map<String, dynamic>> getValidacion({@required int userId}) async {
    final response = await _apiHelper.get("$_urlValidacion/$userId");
    print(response.toString());
    return response["data"];
  }

  Future<Map<String, dynamic>> addArchivos(Map<String, dynamic> files) async {
    String payload = json.encode(files);
    final response = await _apiHelper.post(_urlArchivos, payload);
    return response["data"];
  }

  Future<Parcela> addParcela({@required int userId, @required String item, @required int categoryId, @required int plotId}) async {
    String payload = json.encode({"id": userId, "item": item, "category_id": categoryId, "plots_id": plotId});
    final response = await _apiHelper.post(_urlAddParcela, payload);
    return Parcela.fromJson(response["data"]);
  }

  Future<void> deleteParcela({@required String idUnico }) async {
    String payload = json.encode({"id_unico": idUnico});
    return await _apiHelper.post(_urlDeleteParcela, payload);
  }
   Future<void> deleteParcela2({@required String idUnico }) async {
    String payload = json.encode({"id_unico": idUnico});
    return await _apiHelper.post(_urlDeleteParcelaMoral, payload);
  }
  
  Future<List<Parcela>> getParcelas({String curp}) async {
    
    final response = await _apiHelper.get("$_urlParcelasFisico/$curp");
    
    print(response.toString());
    return GeolocationsModel.fromJson(response).parcelas;
  }
 Future<List<Parcela>> getParcelas2({String rfc}) async {
    
    final response = await _apiHelper.get("$_urlParcelasMoral/$rfc");
    
    print(response.toString());
    return GeolocationsModel.fromJson(response).parcelas;
  }
 
}